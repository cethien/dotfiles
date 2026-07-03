local eizo = "desc:Eizo Nanao Corporation EV2430 33096078"
local lpt_main = "eDP-1"

hl.defaultWorkspace.browser = "1"
hl.defaultWorkspace.pip = "1"
hl.defaultWorkspace.spotify = "5"

hl.monitor({
	output = eizo,
	mode = "1920x1200@60",
	position = "0x0",
	scale = 1,
})

hl.monitor({
	output = lpt_main,
	mode = "1920x1080@60",
	position = "1920x0",
	scale = 1,
})

hl.workspace_rule({
	workspace = "1",
	monitor = eizo,
	persistent = true,
	default = true,
})

hl.workspace_rule({
	workspace = "5",
	monitor = lpt_main,
	persistent = true,
	default = true,
})

hl.bind("SUPER + F12", hl.dsp.exec_cmd("slack"))
