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
          hyprshot_base_cmd = "hyprshot --freeze --clipboard-only --raw";
          satty_cmd = "satty --filename - --config ${config.home.homeDirectory}/.config/satty/config.toml";
        in
        [
          "SUPER SHIFT, S, exec, ${hyprshot_base_cmd} -m region | ${satty_cmd}"
          ", Print, exec, ${hyprshot_base_cmd} -m window | ${satty_cmd}"
        ];
    };
  };
}
