vim.api.nvim_create_user_command("Genpass", function(opts)
	local args = opts.args ~= "" and opts.args or "24"
	local cmd = "genpass " .. args

	local handle = io.popen(cmd)
	if not handle then
		vim.notify("Failed to execute genpass", vim.log.levels.ERROR)
		return
	end

	local password = handle:read("*a")
	handle:close()

	if password then
		password = password:gsub("%s+", "")
	end

	if not password or password == "" then
		vim.notify("genpass returned an empty password", vim.log.levels.WARN)
		return
	end

	local cursor = vim.api.nvim_win_get_cursor(0)
	local row, col = cursor[1], cursor[2]
	vim.api.nvim_buf_set_text(0, row - 1, col, row - 1, col, { password })
	vim.api.nvim_win_set_cursor(0, { row, col + #password })
end, {
	nargs = "?",
})
