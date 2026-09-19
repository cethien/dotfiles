{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  cfg = config.services.mako;
in {
  config = mkIf cfg.enable {
    stylix.targets.mako.opacity.enable = false;

    wayland.windowManager.hyprland.extraLuaFiles = {
      "99-mako" =
        #lua
        ''
          hl.bind("SUPER + A", hl.dsp.exec_cmd("makoctl dismiss -a"))

          local function toggle_dnd()
          	-- Fetch current mode
          	local handle = io.popen("makoctl mode")
          	local raw_mode = handle and handle:read("*a") or ""
          	if handle then
          		handle:close()
          	end

          	-- Check if 'dnd' exists in the raw output stream
          	if raw_mode:find("dnd") then
          		os.execute("makoctl mode -s default")
          		swayosd("--custom-icon notifications-active --custom-message 'Notifications Enabled'")
          	else
          		os.execute("makoctl mode -s dnd")
          		swayosd("--custom-icon notifications-disabled --custom-message 'Do Not Disturb'")
          	end
          end

          hl.bind("SUPER + SHIFT + A", toggle_dnd)
        '';
    };

    services.mako.settings = {
      "urgency=critical" = {
        border-color = "#ff0000";
        default-timeout = 0;
      };

      "mode=dnd" = {
        invisible = 1;
        default-timeout = 0;
      };

      actions = true;
      anchor = "top-center";
      border-radius = 4;
      default-timeout = 6000;
      ignore-timeout = false;
      height = 400;
      icons = true;
      layer = "overlay";
      margin = "16,8,8";
      padding = 16;
      markup = true;
      width = 600;
    };
  };
}
