{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.programs.thunderbird;
in {
  options.programs.thunderbird.autostart = mkEnableOption "thunderbird autostart";

  config = mkIf cfg.enable {
    programs.thunderbird = {
      languagePacks = ["en-US" "en-GB" "de"];
    };

    services.mako.settings."app-name=Thunderbird" = {
      default-timeout = 0;
      border-color = "#0a84ae";
    };

    xdg.configFile."autostart/thunderbird.desktop" = mkIf cfg.autostart {
      text = ''
        [Desktop Entry]
        Name=Thunderbird
        Comment=Mail & Calendar
        Exec=thunderbird
        Icon=thunderbird
        Terminal=false
        Type=Application
        Categories=Network;Email;
      '';
    };

    wayland.windowManager.hyprland.extraLuaFiles."99-thunderbird" =
      # lua
      ''
        local shadow_realm = "special:shadow_realm"

        hl.window_rule({
        	match = {
        		class = "^(thunderbird)$",
        	},
        	workspace = shadow_realm .. " silent",
        })

        hl.bind("SUPER + C", function()
        	local w = hl.get_window("class:^(thunderbird|spotify)$")
        	hl.dispatch(hl.dsp.window.move({ workspace = shadow_realm, window = w, follow = false }))
        end)

        local toggle_thunderbird = function()
        	local w = hl.get_window("class:^(thunderbird)$")

        	if not w then
        		hl.dsp.exec_cmd("thunderbird")
        	elseif w.workspace then
        		hl.dispatch(hl.dsp.window.move({ workspace = "e+0", window = "address:" .. w.address, follow = true }))
        	else
        		hl.dispatch(hl.dsp.focus({ window = "address:" .. w.address }))
        	end
        end

        hl.bind("SUPER + SHIFT + F12", toggle_thunderbird)
        hl.bind("SHIFT + XF86Mail", toggle_thunderbird)
      '';
  };
}
