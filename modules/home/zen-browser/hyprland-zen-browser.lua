hl.window_rule({
	match = {
		initial_class = "^(zen-beta)$",
		initial_title = "^(Picture-in-Picture)$",
	},
	workspace = hl.defaultWorkspace.pip,
	no_initial_focus = true,
	suppress_event = "activatefocus",
})

hl.window_rule({
	match = {
		initial_class = "^(zen-beta)$",
		title = "^(Developer Tools - .*)$",
	},
	tile = true,
})

hl.bind("SUPER + W", function()
	local active_win = hl.get_active_window()
	local browser_ws = hl.defaultWorkspace.browser or 2

	if active_win and active_win.fullscreen and active_win.fullscreen > 0 then
		return
	end

	local w = hl.get_window("class:^zen-beta$")
	if not w then
		hl.dispatch(hl.dsp.exec_cmd("zen-beta"))
		return
	end

	local current_ws = hl.get_active_workspace()

	if active_win and active_win.address == w.address then
		if current_ws and current_ws.id ~= browser_ws then
			hl.dispatch(hl.dsp.window.move({ window = "address:" .. w.address, workspace = browser_ws }))
			hl.dispatch(hl.dsp.focus({ window = "address:" .. w.address }))
		end
		return
	end

	if current_ws then
		hl.dispatch(hl.dsp.window.move({ window = "address:" .. w.address, workspace = current_ws.id }))
		hl.dispatch(hl.dsp.focus({ window = "address:" .. w.address }))
	end
end)

hl.on("window.fullscreen", function()
	local active_win = hl.get_active_window()
	if not active_win then
		return
	end

	if active_win.fullscreen and active_win.fullscreen > 0 then
		if active_win.class == "zen-beta" then
			return
		else
			local zen = hl.get_window("class:^zen-beta$")
			if zen then
				local fallback_workspace = hl.defaultWorkspace.browser or 2
				hl.dispatch(hl.dsp.window.move({
					window = "address:" .. zen.address,
					workspace = fallback_workspace,
					follow = false,
				}))
			end
		end
	end
end)
