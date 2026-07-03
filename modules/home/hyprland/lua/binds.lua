--  Apps
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl s 5%+"), { locked = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl s 5%-"), { locked = true })
hl.bind("SUPER + SHIFT + C", hl.dsp.exec_cmd("hyprpicker -a"))

local toggleLayout = function()
	local workspace = hl.get_active_special_workspace() or hl.get_active_workspace()
	if not workspace then
		return
	end

	local next_layout = "scrolling"
	if workspace.tiled_layout == "scrolling" then
		next_layout = "master"
	end

	local ws_target = workspace.special and tostring(workspace.name) or tostring(workspace.id)
	hl.workspace_rule({ workspace = ws_target, layout = next_layout })
end

hl.bind("SUPER + J", toggleLayout)

-- Core Window Management
local close_or_hide = function()
	local active_w = hl.get_active_window()
	if not active_w then
		return
	end

	for pattern in pairs(hl_persistent_apps) do
		if string.find(active_w.class, pattern) then
			hl.dispatch(hl.dsp.window.move({
				workspace = "special:shadow_realm",
				window = "address:" .. active_w.address,
				follow = false,
			}))
			return
		end
	end

	hl.dispatch(hl.dsp.window.close())
end
hl.bind("SUPER + Q", close_or_hide)

hl.bind("SUPER + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind("SUPER + F", hl.dsp.window.fullscreen({ action = "toggle" }))

-- Move Focus
hl.bind("SUPER + left", hl.dsp.focus({ direction = "left" }))
hl.bind("SUPER + right", hl.dsp.focus({ direction = "right" }))
hl.bind("SUPER + up", hl.dsp.focus({ direction = "up" }))
hl.bind("SUPER + down", hl.dsp.focus({ direction = "down" }))

-- Scroll through Workspaces
hl.bind("SUPER + CTRL + right", hl.dsp.focus({ workspace = "e+1" }))
hl.bind("SUPER + CTRL + left", hl.dsp.focus({ workspace = "e-1" }))

for i = 0, 9 do
	local target = (i == 0) and 10 or i
	hl.bind("SUPER + " .. i, hl.dsp.focus({ workspace = target }))
	hl.bind("SUPER + CTRL + SHIFT + " .. i, hl.dsp.window.move({ workspace = target }))
end

-- Move Windows
hl.bind("SUPER + SHIFT + left", hl.dsp.window.move({ direction = "left" }))
hl.bind("SUPER + SHIFT + right", hl.dsp.window.move({ direction = "right" }))
hl.bind("SUPER + SHIFT + up", hl.dsp.window.move({ direction = "up" }))
hl.bind("SUPER + SHIFT + down", hl.dsp.window.move({ direction = "down" }))

hl.bind("SUPER + CTRL + SHIFT + right", hl.dsp.window.move({ workspace = "e+1" }))
hl.bind("SUPER + CTRL + SHIFT + left", hl.dsp.window.move({ workspace = "e-1" }))

local ri = 25
hl.bind(
	"SUPER + ALT + right",
	hl.dsp.window.resize({
		x = ri,
		y = 0,
		relative = true,
	}),
	{ repeating = true }
)
hl.bind(
	"SUPER + ALT + left",
	hl.dsp.window.resize({
		x = -ri,
		y = 0,
		relative = true,
	}),
	{ repeating = true }
)
hl.bind(
	"SUPER + ALT + up",
	hl.dsp.window.resize({
		x = 0,
		y = -ri,
		relative = true,
	}),
	{ repeating = true }
)
hl.bind(
	"SUPER + ALT + down",
	hl.dsp.window.resize({
		x = 0,
		y = ri,
		relative = true,
	}),
	{ repeating = true }
)

hl.bind("SUPER + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind("SUPER + mouse:273", hl.dsp.window.resize(), { mouse = true })
