local selected_or_hovered = ya.sync(function()
	local tab, paths = cx.active, {}
	for _, u in pairs(tab.selected) do
		paths[#paths + 1] = tostring(u)
	end
	if #paths == 0 and tab.current.hovered then
		paths[1] = tostring(tab.current.hovered.url)
	end
	return paths
end)

local function fail(s, ...)
	ya.notify({
		title = "ffmpeg convert",
		content = string.format(s, ...),
		level = "error",
		timeout = 5,
	})
end

return {
	entry = function()
		ya.emit("escape", { visual = true })

		local urls = selected_or_hovered()
		if #urls == 0 then
			return ya.notify({
				title = "ffmpeg convert",
				content = "No file selected",
				level = "warn",
				timeout = 5,
			})
		end

		local format, event = ya.input({
			title = "target format (eg. mp4, wav):",
			pos = { "top-center", y = 3, w = 40 },
		})

		if event ~= 1 or format == "" then
			return
		end

		for _, input in ipairs(urls) do
			local output = input:gsub("%.[^%.]+$", "") .. "." .. format

			-- Use spawn and wait for the status
			local child, err = Command("ffmpeg"):arg("-i"):arg(input):arg("-y"):arg(output):spawn()

			if not child then
				fail("Failed to spawn ffmpeg: %s", err)
				break
			end

			local status = child:wait()

			if not status or not status.success then
				fail("Failed to convert %s", input)
				break
			end
		end

		ya.notify({ title = "Convert", content = "Process complete", timeout = 3 })
	end,
}
