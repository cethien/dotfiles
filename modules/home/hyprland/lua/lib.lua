hl_persistent_apps = {}

function register_persistent_app(class_pattern)
	hl_persistent_apps[class_pattern] = true
end

hl.defaultWorkspace = {}

function game_windowrule(match_config)
	hl.window_rule({
		match = match_config,
		workspace = hl.defaultWorkspace.game,
		content = "game",
	})
end

function Modal(name, config)
	local class = config.class or name
	local exec = config.exec or name

	local exec_cmd = exec
	if config.terminal ~= false then
		exec_cmd = string.format("kitty --class %s -e %s", class, exec)
	end

	hl.workspace_rule({
		workspace = "special:" .. name,
		on_created_empty = exec_cmd,
		gaps_in = 0,
		gaps_out = 200,
	})

	hl.window_rule({
		match = { class = "^(" .. class .. ")$" },
		workspace = "special:" .. name .. " silent",
	})

	if config.binds then
		for _, bind in ipairs(config.binds) do
			hl.bind(bind, hl.dsp.workspace.toggle_special(name))
		end
	end
end
