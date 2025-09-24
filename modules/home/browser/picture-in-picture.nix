{
  lib,
  config,
  ...
}: let
  inherit (lib) mkOption types;
  cfg = config.deeznuts.programs.browser.picture-in-picture;
in {
  options.deeznuts.programs.browser.picture-in-picture = {
    hyprland.workspace = mkOption {
      type = types.int;
      default = 6;
      description = "default workspace";
    };
  };

  config = {
    wayland.windowManager.hyprland.settings = {
      windowrulev2 = [
        "workspace ${toString cfg.hyprland.workspace}, title:^(Picture-in-Picture)$"
      ];
    };
  };
}
