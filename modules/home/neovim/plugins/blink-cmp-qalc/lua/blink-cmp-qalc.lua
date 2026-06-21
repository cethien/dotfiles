--- @module 'blink.cmp'

local task_ok, task = pcall(function()
	return require("blink.cmp.lib.async").task
end)
if not task_ok then
	task = require("blink.lib.task")
end

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
	local chained_task = task.new(function()
		local cursor_col = ctx.cursor[2]
		local line_up_to_cursor = ctx.line:sub(1, cursor_col)

		local escaped_trigger = self.trigger:gsub("([^%w])", "%%%1")
		local trigger_pos, expr =
			line_up_to_cursor:match(".*()(" .. escaped_trigger .. "([^" .. escaped_trigger .. "]*))$")

		if not trigger_pos or not expr or expr == "" then
			callback()
			return function() end
		end

		local pure_expr = expr:sub(#self.trigger + 1)
		pure_expr = pure_expr:match("^%s*(.-)%s*$")

		if pure_expr == "" then
			callback()
			return function() end
		end

		local cmd_args = { "qalc", "-t" }
		for _, opt in ipairs(self.set_options) do
			table.insert(cmd_args, string.format('-s "%s"', opt))
		end
		table.insert(cmd_args, string.format("%q", pure_expr))

		local cmd = table.concat(cmd_args, " ")
		local handle = io.popen(cmd)
		if not handle then
			callback()
			return function() end
		end

		local result = handle:read("*a")
		handle:close()

		if result then
			result = result:gsub("^%s*(.-)%s*$", "%1")
		end

		if not result or result == "" or result:find("error") then
			callback()
			return function() end
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

		callback({
			is_incomplete_forward = false,
			is_incomplete_backward = false,
			items = items,
		})

		return function() end
	end)

	return function()
		chained_task:cancel()
	end
end

return QalcSource
