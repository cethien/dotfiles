--- @module 'blink.cmp'

local QalcSource = {}

function QalcSource.new(opts)
	local self = setmetatable({}, { __index = QalcSource })

	self.opts = opts or {}
	self.trigger = self.opts.trigger or "="
	self.set_options = self.opts.set_options or { "group 0", "fr 0", "maxdeci 4", "conv 2" }

	return self
end

function QalcSource:is_available()
	return vim.fn.executable("qalc") == 1
end

function QalcSource:get_trigger_characters()
	return { self.trigger }
end

function QalcSource:get_completions(ctx, callback)
	local cursor_col = ctx.cursor[2]
	local line_up_to_cursor = ctx.line:sub(1, cursor_col)

	local escaped_trigger = self.trigger:gsub("([^%w])", "%%%1")
	local trigger_pos, expr = line_up_to_cursor:match(".*()(" .. escaped_trigger .. "([^" .. escaped_trigger .. "]*))$")

	if not trigger_pos or not expr or expr == "" then
		callback()
		return function() end
	end

	local pure_expr = expr:sub(#self.trigger + 1):match("^%s*(.-)%s*$")

	if pure_expr == "" then
		callback()
		return function() end
	end

	-- Arguments sauber als Array aufbauen
	local cmd_args = { "-t" }
	for _, opt in ipairs(self.set_options) do
		table.insert(cmd_args, "-s")
		table.insert(cmd_args, opt)
	end
	table.insert(cmd_args, pure_expr)

	-- ECHT ASYNCHRON mit vim.system
	local obj = vim.system({ "qalc", unpack(cmd_args) }, { text = true }, function(out)
		if out.code ~= 0 or not out.stdout then
			vim.schedule(callback)
			return
		end

		local result = out.stdout:gsub("^%s*(.-)%s*$", "%1")

		if result == "" or result:find("error") then
			vim.schedule(callback)
			return
		end

		local start_character = trigger_pos - 1

		local items = {
			{
				label = expr .. " -> " .. result,
				kind = require("blink.cmp.types").CompletionItemKind.Value,
				insertText = result,
				detail = "qalc",
				textEdit = {
					newText = result,
					range = {
						start = { line = ctx.cursor[1] - 1, character = start_character },
						["end"] = { line = ctx.cursor[1] - 1, character = cursor_col },
					},
				},
			},
		}

		vim.schedule(function()
			callback({
				is_incomplete_forward = false,
				is_incomplete_backward = false,
				items = items,
			})
		end)
	end)

	return function()
		if obj and not obj:is_closing() then
			obj:kill(9)
		end
	end
end

return QalcSource
