{ lib, config, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkOption types mkIf;
  cfg = config.deeznuts.programs.vscode;
in
{
  options.deeznuts.programs.vscode = {
    enable = mkEnableOption "VSCode and Chromium";
    hyprland.workspace = mkOption {
      type = types.int;
      default = config.deeznuts.programs.hyprland.defaultWorkspaces.development;
      description = "default hyprland workspace";
    };
    chromium.hyprland.workspace = mkOption {
      type = types.int;
      default = 4;
      description = "default hyprland workspace";
    };
  };

  config = mkIf cfg.enable {
    wayland.windowManager.hyprland.settings = {
      windowrulev2 = [
        "workspace ${toString cfg.hyprland.workspace}, class:Code"
        "workspace ${toString cfg.chromium.hyprland.workspace}, class:Chromium-browser"
      ];
    };

    home.packages = [ pkgs.nerd-fonts.meslo-lg ];
    programs.vscode.enable = true;
    programs.chromium.enable = true;
  };
}
