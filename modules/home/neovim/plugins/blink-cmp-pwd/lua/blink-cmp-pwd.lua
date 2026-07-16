--- @module 'blink.cmp'

local task_ok, task = pcall(function()
	return require("blink.cmp.lib.async").task
end)
if not task_ok then
	task = require("blink.lib.task")
end

local PwdSource = {}

function PwdSource.new(opts)
	local self = setmetatable({}, { __index = PwdSource })

	self.opts = opts or {}
	-- Beide Trigger direkt aus den Opts konfigurierbar machen
	self.trigger = self.opts.trigger or "§"
	self.trigger_no_special = self.opts.trigger_no_special or "§§"
	self.default_length = self.opts.default_length or 24

	return self
end

function PwdSource:is_available()
	return vim.fn.executable("genpass") == 1
end

function PwdSource:get_trigger_characters()
	-- Holt jeweils das erste Zeichen der Trigger (damit blink anspringt)
	local chars = {}
	if self.trigger and self.trigger ~= "" then
		table.insert(chars, self.trigger:sub(1, 1))
	end
	if self.trigger_no_special and self.trigger_no_special ~= "" then
		local first_char = self.trigger_no_special:sub(1, 1)
		if first_char ~= chars[1] then
			table.insert(chars, first_char)
		end
	end
	return chars
end

function PwdSource:get_completions(ctx, callback)
	local chained_task = task.new(function()
		local cursor_col = ctx.cursor[2]
		local line_up_to_cursor = ctx.line:sub(1, cursor_col)

		local esc_with = vim.pesc(self.trigger)
		local esc_without = vim.pesc(self.trigger_no_special)

		local trigger_pos, expr, input_str
		local no_special_chars = false

		-- 1. Check auf den "No-Special"-Trigger (z.B. §§28)
		-- Muss zuerst gematcht werden, da dieser meist länger ist
		trigger_pos, expr, input_str = line_up_to_cursor:match(".*()(" .. esc_without .. "(%d*))$")

		if trigger_pos then
			no_special_chars = true
		else
			-- 2. Fallback auf den Standard-Trigger (z.B. §28)
			trigger_pos, expr, input_str = line_up_to_cursor:match(".*()(" .. esc_with .. "(%d*))$")
		end

		if not trigger_pos or not expr or expr == "" then
			callback()
			return function() end
		end

		-- Länge parsen
		local length = self.default_length
		if input_str and input_str ~= "" then
			length = tonumber(input_str) or self.default_length
		end

		-- Befehl für genpass bauen
		local cmd_args = { "genpass" }
		if no_special_chars then
			table.insert(cmd_args, "-dlu")
		end
		table.insert(cmd_args, tostring(length))

		local cmd = table.concat(cmd_args, " ")
		local handle = io.popen(cmd)
		if not handle then
			callback()
			return function() end
		end

		local password = handle:read("*a")
		handle:close()

		if password then
			password = password:gsub("%s+", "")
		end

		if not password or password == "" then
			callback()
			return function() end
		end

		-- UTF-8 sichere Ersetzung
		local byte_idx = trigger_pos - 1
		local start_character = vim.fn.charidx(ctx.line, byte_idx)

		local items = {
			{
				label = string.format(
					"Pwd: %s (len: %d, plain: %s)",
					password:sub(1, 6) .. "...",
					length,
					tostring(no_special_chars)
				),
				kind = require("blink.cmp.types").CompletionItemKind.Value,
				insertText = password,
				detail = "genpass",
				textEdit = {
					newText = password,
					range = {
						start = { line = ctx.cursor[1] - 1, character = start_character },
						["end"] = { line = ctx.cursor[1] - 1, character = ctx.cursor[2] },
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

return PwdSource
