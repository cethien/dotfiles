{
  lib,
  config,
  pkgs,
  pkgs-unstable,
  ...
}: let
  inherit (lib) mkIf;
  cfg = config.wayland.windowManager.hyprland;
in {
  imports = [
    ./battery-checker.nix
    ./notify-info.nix
    ./rofi
    ./hypridle.nix
    ./hyprlock.nix
    ./grimblast.nix
    ./text-extract.nix
    ./mako.nix
  ];

  config = mkIf cfg.enable {
    xdg.portal = {
      enable = true;
      extraPortals = with pkgs-unstable; [
        xdg-desktop-portal-gtk
      ];
      config = {
        common = {
          default = ["gtk"];
        };
        hyprland = {
          default = [
            "hyprland"
            "gtk"
          ];
        };
      };
    };

    xdg.configFile = {
      "hypr/xdph.conf".text = ''
        screencopy {
          allow_token_by_default = true
        }
      '';
    };

    home.packages = with pkgs; [
      xrandr
      libnotify
      playerctl
      brightnessctl
      wl-clipboard
    ];

    programs = {
      hyprlock.enable = true;

      kitty.enable = true;
      rofi.enable = true;
      mpv.enable = true;
      imv.enable = true;
      zathura.enable = true;
      fileroller.enable = true;
      nautilus.enable = true;
      grimblast.enable = true;
      text-extract.enable = true;
    };

    services = {
      mako.enable = true;
      swayosd.enable = true;
      battery-checker.enable = true;
      hyprpaper.enable = true;
    };

    wayland.windowManager.hyprland = {
      configType = "lua";
      extraLuaFiles = {
        "00-lib".content = ./lua/lib.lua;
        "01-settings".content = ./lua/hyprland.lua;
        "02-animations".content = ./lua/animations.lua;
        "03-windowrules".content = ./lua/windowrules.lua;
        "04-binds".content = ./lua/binds.lua;
        "05-swayosd" =
          # lua
          ''
            hl.swayosdMonitor = nil

            function swayosd(cmd)
            	local full_cmd = "swayosd-client " .. cmd
            	if hl.swayosdMonitor and hl.swayosdMonitor ~= "" then
            		full_cmd = full_cmd .. " --monitor " .. hl.swayosdMonitor
            	end
            	hl.exec_cmd(full_cmd)
            end

            hl.on("input.keyboard.key", function(keycode, timestamp, state)
            	if state == 0 then
            		if keycode == 66 then
            			swayosd("--caps-lock")
            		elseif keycode == 77 then
            			swayosd("--num-lock")
            		elseif keycode == 78 then
            			swayosd("--scroll-lock")
            		end
            	end
            end)
          '';
      };
      extraConfig =
        # lua
        ''require("scratchpad")'';
    };
  };
}
