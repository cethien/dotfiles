hl.window_rule({
	match = { class = ".*" },
	suppress_event = "maximize",
})

hl.window_rule({
	match = { initial_class = "xdg-desktop-portal-gtk" },
	tile = true,
})

hl.window_rule({
	match = { float = true },
	center = true,
})

hl.window_rule({
	match = {
		class = "^$",
		title = "^$",
		xwayland = true,
		float = true,
		fullscreen = false,
		pin = false,
	},
	no_focus = true,
})
