{ config, lib, pkgs, ... }:
let
  inherit (lib) mkIf;
  enabled = config.deeznuts.programs.hyprland.enable;
in
{
  config = mkIf enabled {
    home.packages = with pkgs; [
      hyprshot
      satty
    ];

    home.file.".config/satty/config.toml".source = ./satty/config.toml;

    wayland.windowManager.hyprland.settings = {
      bind =
        let
          hyprshot_base_cmd = "hyprshot --freeze --clipboard-only --raw";
          satty_cmd = "satty --filename - --config ${config.home.homeDirectory}/.config/satty/config.toml";
        in
        [
          ", Print, exec, ${hyprshot_base_cmd} -m output | ${satty_cmd}"
          "ALT, Print, exec, ${hyprshot_base_cmd} -m window | ${satty_cmd}"
          "SUPER SHIFT, S, exec, ${hyprshot_base_cmd} -m region | ${satty_cmd}"
        ];
    };
  };
}
