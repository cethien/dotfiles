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
        Exec=hyprctl eval 'hl.dispatch(hl.dsp.exec_cmd("thunderbird", {workspace = "special:shadow_realm silent"}))'
        Icon=thunderbird
        Terminal=false
        Type=Application
        Categories=Network;Email;
      '';
    };

    wayland.windowManager.hyprland.extraLuaFiles."99-thunderbird" =
      # lua
      ''
        register_persistent_app("^(thunderbird)$")

        local show_thunderbird = function()
        	local w = hl.get_window("class:^(thunderbird)$")
        	if not w then
        		hl.dispatch(hl.dsp.exec_cmd("thunderbird"))
        		return
        	end

        	hl.dispatch(hl.dsp.window.move({
        		workspace = "e+0",
        		window = "address:" .. w.address,
        		follow = true,
        	}))
        	hl.dispatch(hl.dsp.focus({ window = "address:" .. w.address }))
        end

        hl.bind("SUPER + SHIFT + F12", show_thunderbird)
        hl.bind("SHIFT + XF86Mail", show_thunderbird)
      '';
  };
}
