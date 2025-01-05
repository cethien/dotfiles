{ config, lib, pkgs, ... }:
let
  inherit (lib) mkIf;
  enable = config.deeznuts.desktop.hyprland.enable;
in
{
  config = mkIf enable {
    home.packages = with pkgs; [
      hyprshot
      satty
    ];

    home.file.".config/satty/config.toml".source = ./config.toml;

    wayland.windowManager.hyprland.settings = {
      bind =
        let
          satty_cmd = "satty --filename - --config ${config.home.homeDirectory}/.config/satty/config.toml";
        in
        [
          "SUPER SHIFT, S, exec, hyprshot -m region --raw | ${satty_cmd}"
          ", Print, exec, hyprshot -m window --raw | ${satty_cmd}"
        ];

      windowrulev2 = [
        "float, class:^(com.gabm.satty)$"
        "center, class:^(com.gabm.satty)$"
        "size 1640 990, class:^(com.gabm.satty)$"
      ];
    };
  };
}
