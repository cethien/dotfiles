Modal("wiremix", {
	binds = {
		"SUPER + SHIFT + M",
		"SHIFT + XF86Music",
		"SHIFT + XF86Tools",
	},
})

-- Global volume controls (Super + Volume keys)
hl.bind("SUPER + XF86AudioRaiseVolume", function()
	os.execute("wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%+")
end)
hl.bind("SUPER + XF86AudioLowerVolume", function()
	os.execute("wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%-")
end)

-- Helper to execution system-wide endpoint toggles (Mic, Speaker)
local function toggle_system_mute(target, name, icon_on, icon_off)
	os.execute(string.format("wpctl set-mute %s toggle", target))

	local handle = io.popen(string.format("wpctl get-volume %s", target))
	if handle then
		local result = handle:read("*a")
		handle:close()

		if result:find("MUTED") then
			os.execute(string.format("notify-send '%s %s' 'muted'", icon_off, name))
		else
			os.execute(string.format("notify-send '%s %s' 'unmuted'", icon_on, name))
		end
	end
end

-- System-wide AFK Toggle
local function toggle_afk()
	local mic_handle = io.popen("wpctl get-volume @DEFAULT_AUDIO_SOURCE@")
	local spk_handle = io.popen("wpctl get-volume @DEFAULT_AUDIO_SINK@")
	local mic_res = mic_handle and mic_handle:read("*a") or ""
	local spk_res = spk_handle and spk_handle:read("*a") or ""
	if mic_handle then
		mic_handle:close()
	end
	if spk_handle then
		spk_handle:close()
	end

	if not mic_res:find("MUTED") or not spk_res:find("MUTED") then
		os.execute("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ 1")
		os.execute("wpctl set-mute @DEFAULT_AUDIO_SINK@ 1")
		os.execute("notify-send '󰩈 afk' 'goodbye'")
	else
		os.execute("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ 0")
		os.execute("wpctl set-mute @DEFAULT_AUDIO_SINK@ 0")
		os.execute("notify-send '󰟀 afk' 'welcome back'")
	end
end

-- Unified helper for application specific volume/mute actions
local function apply_focused_action(action, amount)
	local active_window = hl.get_active_window()

	if active_window and active_window.pid then
		local shell_cmd = string.format(
			[=[ pw-dump | jq '.[] | select(.info.props["application.process.id"] == %d) | .id' ]=],
			active_window.pid
		)

		local handle = io.popen(shell_cmd)
		if handle then
			for node_id in handle:lines() do
				if tonumber(node_id) then
					local cmd
					if action == "volume" then
						cmd = string.format("wpctl set-volume -l 1.0 %s %s", node_id, amount)
					elseif action == "mute" then
						cmd = string.format("wpctl set-mute %s toggle", node_id)
					end

					if cmd then
						os.execute(cmd)
					end
				end
			end
			handle:close()
		end
	end
end

-- Focus volume & mute controls
hl.bind("XF86AudioRaiseVolume", function()
	apply_focused_action("volume", "5%+")
end)
hl.bind("XF86AudioLowerVolume", function()
	apply_focused_action("volume", "5%-")
end)
hl.bind("XF86AudioMute", function()
	apply_focused_action("mute")
end)

-- Mic Mute mappings
local function toggle_mic()
	toggle_system_mute("@DEFAULT_AUDIO_SOURCE@", "mic", "󰍬", "󰍭")
end
hl.bind("XF86AudioMicMute", toggle_mic, { locked = true })
hl.bind("ALT + XF86AudioMute", toggle_mic, { locked = true })
hl.bind("SUPER + ALT + F9", toggle_mic, { locked = true })

-- Speaker Mute mappings (Super + Shift)
local function toggle_speakers()
	toggle_system_mute("@DEFAULT_AUDIO_SINK@", "speakers", "󰓃", "󰓄")
end
hl.bind("SUPER + XF86AudioMute", toggle_speakers, { locked = true })
hl.bind("SUPER + SHIFT + F9", toggle_speakers, { locked = true })

-- AFK Mute mappings
hl.bind("SUPER + SHIFT + XF86AudioMute", toggle_afk, { locked = true })
hl.bind("SUPER + F9", toggle_afk, { locked = true })
