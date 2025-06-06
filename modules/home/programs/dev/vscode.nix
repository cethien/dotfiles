{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.deeznuts.programs.dev.vscode;
in {
  options.deeznuts.programs.dev.vscode = {
    enable = mkEnableOption "vscode";
  };

  config = mkIf cfg.enable {
    wayland.windowManager.hyprland.settings = {
      windowrulev2 = [
        "workspace ${toString cfg.hyprland.workspace}, class:Code"
      ];
    };

    home.packages = [pkgs.nerd-fonts.meslo-lg];
    programs.vscode.enable = true;
  };
}
