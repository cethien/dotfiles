{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  cfg = config.programs.wiremix;
in {
  config = mkIf cfg.enable {
    programs.wiremix = {
      package = pkgs.unstable.wiremix;
      settings = {
        max_volume_percent = 115.0;
        tabs = ["playback" "output" "recording" "input" "configuration"];
        keybindings = [
          {
            key = {F = 1;};
            action = {SelectTab = 0;};
          }
          {
            key = {F = 2;};
            action = {SelectTab = 1;};
          }
          {
            key = {F = 3;};
            action = {SelectTab = 2;};
          }
          {
            key = {F = 4;};
            action = {SelectTab = 3;};
          }
          {
            key = {F = 5;};
            action = {SelectTab = 4;};
          }
        ];
      };
    };

    home.packages = [pkgs.crosspipe];

    wayland.windowManager.hyprland.extraLuaFiles = {
      "99-pipewire".content = ./pipewire.lua;
      "99-wiremix".content =
        #lua
        ''
          Modal("wiremix", {
          	binds = {
          		"SUPER + SHIFT + M",
          		"SHIFT + XF86Music",
          		"SHIFT + XF86Tools",
          	},
          })
        '';
    };
  };
}
