hl.curve("deez", {
	type = "bezier",
	points = {
		{ 0.22, 0.85 },
		{ 0, 1.03 },
	},
})

hl.animation({
	leaf = "windows",
	enabled = true,
	speed = 5.0,
	bezier = "deez",
	style = "slide",
})

hl.animation({
	leaf = "border",
	enabled = true,
	speed = 3.0,
	bezier = "deez",
})

hl.animation({
	leaf = "fade",
	enabled = true,
	speed = 3.0,
	bezier = "deez",
})

hl.animation({
	leaf = "workspaces",
	enabled = true,
	speed = 2.0,
	bezier = "deez",
})

hl.animation({
	leaf = "specialWorkspace",
	enabled = true,
	speed = 3.0,
	bezier = "deez",
	style = "slidevert",
})
