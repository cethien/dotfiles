local function info(content)
	return ya.notify({
		title = "Yank Directory Content",
		content = content,
		timeout = 5,
	})
end

local hovered_url = ya.sync(function()
	local h = cx.active.current.hovered
	return h and h.url
end)

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
		return extensions[ext]
	end
	return nil
end

local function split_path(path)
	local parts = {}
	for part in path:gmatch("[^/]+") do
		table.insert(parts, part)
	end
	return parts
end

local function format_path(path, base_path)
	return path:sub(#base_path + 2) -- +2 to remove leading '/'
end

-- Improved path comparison function
local function compare_paths(a, b)
	local a_parts = split_path(a)
	local b_parts = split_path(b)
	for i = 1, math.min(#a_parts, #b_parts) do
		if a_parts[i] ~= b_parts[i] then
			if a_parts[i]:match("%.yazi$") and not b_parts[i]:match("%.yazi$") then
				return false
			elseif b_parts[i]:match("%.yazi$") and not a_parts[i]:match("%.yazi$") then
				return true
			else
				return a_parts[i] < b_parts[i]
			end
		end
	end
	return #a_parts < #b_parts
end

-- Function to generate ASCII tree
local function generate_tree(dir_url)
	local output, err = Command("tree")
		:arg("-L")
		:arg("3") -- Limit depth to 3 levels, adjust as needed
		:arg("--charset=ascii") -- Use ASCII characters for compatibility
		:arg(tostring(dir_url))
		:output()

	if not output then
		return "Failed to generate tree, error: " .. err
	end

	return output.stdout
end

return {
	entry = function()
		local dir_url = hovered_url()
		if not dir_url then
			return info("No directory hovered")
		end

		local is_dir = ya.sync(function()
			return cx.active.current.hovered.cha.is_dir
		end)

		if not is_dir then
			return info("Hovered item is not a directory")
		end

		-- Generate ASCII tree
		local tree_content = generate_tree(dir_url)

		local output, err = Command("find"):arg(tostring(dir_url)):output()
		if not output then
			return info("Failed to list directory contents, error: " .. err)
		end

		local paths = {}
		for path in output.stdout:gmatch("[^\r\n]+") do
			table.insert(paths, path)
		end
		table.sort(paths, compare_paths)

		local content = tree_content .. "\n\n" -- Add tree content at the top
		local prev_parts = {}
		local total_lines = 0
		local file_count = 0
		local skipped_count = 0

		for _, path in ipairs(paths) do
			local formatted_path = format_path(path, tostring(dir_url))
			local parts = split_path(formatted_path)
			local is_file = ya.sync(function()
				return not fs.stat(path).is_dir
			end)

			-- Output headers for new directories
			for i = 1, #parts do
				if i > #prev_parts or parts[i] ~= prev_parts[i] then
					content = content .. string.rep("#", i) .. " " .. table.concat(parts, "/", 1, i) .. "\n"
					if i == #parts and not is_file then
						content = content .. "````\n````\n" -- Add empty code block for directories
					end
				end
			end

			if is_file then
				local language = get_language(path)
				if language then
					local file_content, file_err = Command("cat"):arg(path):output()
					if file_content then
						content = content .. "````" .. language .. "\n"
						content = content .. file_content.stdout
						content = content .. "````\n\n"

						local file_lines = select(2, file_content.stdout:gsub("\n", "\n"))
						total_lines = total_lines + file_lines
						file_count = file_count + 1
					else
						content = content .. "Error reading file: " .. file_err .. "\n\n"
					end
				else
					skipped_count = skipped_count + 1
				end
			end

			prev_parts = parts
		end

		ya.clipboard(content)
		info(
			string.format(
				"Copied tree and content of %d files (%d lines) to clipboard. Skipped %d unsupported files.",
				file_count,
				total_lines,
				skipped_count
			)
		)
	end,
}
