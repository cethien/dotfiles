-- Configuration
local CONFIG = {
	log_to_file = false, -- Set this to false to disable logging to file
}

local function get_log_file_path()
	local home = os.getenv("HOME")
	return home .. "/.config/yazi/yank-selected-content.log"
end

local function log_to_file(message)
	if not CONFIG.log_to_file then
		return -- Exit the function if logging is disabled
	end
	local log_file = io.open(get_log_file_path(), "a")
	if log_file then
		local timestamp = os.date("%Y-%m-%d %H:%M:%S")
		log_file:write(string.format("[%s] %s\n", timestamp, message))
		log_file:close()
	end
end

local function info(content)
	log_to_file(content)
	return ya.notify({
		title = "Yank Content",
		content = content,
		timeout = 5,
	})
end

local function safe_access(func, default)
	local success, result = pcall(func)
	if success then
		return result
	else
		return "Error: " .. tostring(result)
	end
end

local get_selected_files = ya.sync(function()
	local selected = {}
	for _, u in pairs(cx.active.selected) do
		table.insert(selected, tostring(u))
	end
	return selected
end)

local get_hovered_file = ya.sync(function()
	local h = cx.active.current.hovered
	return h and tostring(h.url)
end)

local function get_file_content(file_path)
	local output, err = Command("cat"):arg(file_path):output()
	if not output then
		return nil, "Failed to read file: " .. file_path .. ", error: " .. err
	end
	return output.stdout, nil
end

local function get_language(file)
	local ext = file:match("%.([^%.]+)$")
	if ext then
		ext = ext:lower()
		local extensions = {
			py = "python",
			js = "javascript",
			html = "html",
			css = "css",
			lua = "lua",
			md = "markdown",
			txt = "text",
			-- Add more as needed
		}
		return extensions[ext] or "text"
	end
	return "text"
end

local function get_common_prefix(paths)
	if #paths == 0 then
		return ""
	end
	local shortest = paths[1]
	for i = 2, #paths do
		if #paths[i] < #shortest then
			shortest = paths[i]
		end
	end
	local common_prefix = ""
	for i = 1, #shortest do
		local char = shortest:sub(i, i)
		for j = 1, #paths do
			if paths[j]:sub(i, i) ~= char then
				return common_prefix
			end
		end
		common_prefix = common_prefix .. char
	end
	return common_prefix:match("(.*/)") or ""
end

local function get_relative_path(file_path, common_prefix)
	return file_path:sub(#common_prefix + 1)
end

return {
	entry = function()
		local selected_files = safe_access(get_selected_files, {})

		if #selected_files == 0 then
			-- No files selected, use hovered file
			local hovered_file = safe_access(get_hovered_file)
			if not hovered_file then
				return info("No file selected or hovered")
			end
			selected_files = { hovered_file }
		end

		local common_prefix = get_common_prefix(selected_files)
		local content = "# Common prefix: " .. common_prefix .. "\n\n"
		local error_messages = {}
		local file_count = 0
		local total_lines = 0

		for _, file_path in ipairs(selected_files) do
			local file_content, err = get_file_content(file_path)
			if file_content then
				local relative_path = get_relative_path(file_path, common_prefix)
				local language = get_language(file_path)
				content = content .. "## " .. relative_path .. "\n"
				content = content .. "````" .. language .. "\n"
				content = content .. file_content
				content = content .. "````\n\n"
				file_count = file_count + 1
				total_lines = total_lines + select(2, file_content:gsub("\n", "\n"))
			else
				table.insert(error_messages, err)
			end
		end

		if content ~= "" then
			ya.clipboard(content)
			local success_message
			if file_count == 1 then
				success_message = string.format("Copied content of 1 file (%d lines) to clipboard", total_lines)
			else
				success_message =
					string.format("Copied content of %d files (%d lines) to clipboard", file_count, total_lines)
			end
			info(success_message)
		end

		if #error_messages > 0 then
			local error_content = "Errors:\n" .. table.concat(error_messages, "\n")
			info(error_content)
		end
	end,
}
