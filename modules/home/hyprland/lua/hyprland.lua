hl.config({
	general = {
		gaps_in = 2,
		gaps_out = 4,
		border_size = 4,
		layout = "scrolling",
	},

	scrolling = {
		column_width = 0.8,
		focus_fit_method = 0,
	},

	master = {
		mfact = 0.6,
		orientation = "right",
	},

	dwindle = {
		preserve_split = true,
		force_split = 1,
	},

	decoration = {
		rounding = 6,

		active_opacity = 1.0,
		inactive_opacity = 0.975,
		fullscreen_opacity = 1.0,

		shadow = {
			range = 12,
			render_power = 3,
		},

		blur = {
			size = 8,
			passes = 3,
			vibrancy = 0.6,
			brightness = 1.0,
			contrast = 1.2,
		},
	},

	cursor = {
		-- inactive_timeout = 5,
		persistent_warps = true,
	},

	xwayland = {
		force_zero_scaling = true,
	},

	misc = {
		force_default_wallpaper = 0,
		disable_hyprland_logo = true,
		disable_splash_rendering = true,
		middle_click_paste = false,
		focus_on_activate = true,
		enable_swallow = true,
	},

	ecosystem = { no_donation_nag = true },

	input = {
		kb_layout = "de",
		kb_variant = "nodeadkeys",
		follow_mouse = 1,
	},
})
