{
  lib,
  config,
  pkgs,
  pkgs-unstable,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.programs.thunderbird;

  autostartScript = pkgs.writeShellScriptBin "thunderbird-autostart" ''
    hyprctl eval 'hl.dispatch(hl.dsp.exec_cmd("thunderbird", {workspace = "special:shadow_realm silent"}))'
  '';

  autostartFile = pkgs.makeDesktopItem {
    name = "thunderbird-autostart";
    exec = "${autostartScript}/bin/thunderbird-autostart";
    desktopName = "Thunderbird (Autostart)";
  };
in {
  options.programs.thunderbird.autostart = mkEnableOption "thunderbird autostart";

  config = mkIf cfg.enable {
    programs.thunderbird = {
      package = pkgs-unstable.thunderbird;
      languagePacks = ["en-US" "en-GB" "de"];
    };

    xdg.autostart.entries = lib.optionals cfg.autostart [
      "${autostartFile}/share/applications/thunderbird-autostart.desktop"
    ];

    services.mako.settings."app-name=Thunderbird" = {
      default-timeout = 0;
      border-color = "#0a84ae";
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
