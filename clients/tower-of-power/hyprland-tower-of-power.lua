local asus = "desc:ASUSTek COMPUTER INC VG27AQML1A S9LMQS167913"
local arzopa = "desc:GWD ARZOPA 000000000001"

hl.defaultWorkspace = {
	game = 3,
	game_launcher = 3,
	browser = 4,
	chat = 4,
	pip = 4,
	spotify = 4,
}

hl.monitor({
	output = asus,
	mode = "2560x1440@240",
	position = "0x0",
	scale = 1,
	bitdepth = 10,
	vrr = 2,
})

hl.workspace_rule({
	workspace = "1",
	monitor = asus,
	persistent = true,
	default = true,
})

hl.workspace_rule({
	monitor = asus,
	workspace = "2",
	persistent = true,
})

hl.workspace_rule({
	monitor = asus,
	workspace = "3",
})

hl.monitor({
	output = arzopa,
	mode = "1920x1080@100",
	position = "320x1440",
	scale = 1,
})

hl.workspace_rule({
	workspace = "4",
	monitor = arzopa,
	persistent = true,
	default = true,
})

hl.config({
	general = {
		allow_tearing = true,
	},
})

hl.on("hyprland.start", function()
	hl.exec_cmd("xrandr --output DP-1 --primary")
end)
