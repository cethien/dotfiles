{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  ws = config.wayland.windowManager.hyprland.defaultWorkspaces.music;
in {
  config = mkIf config.programs.desktop.isEnabled {
    home.packages = with pkgs; [
      wiremix
    ];
    wayland.windowManager.hyprland.settings = {
      windowrule = mkIf (!isNull ws) ["match:initial_class wiremix, workspace ${toString ws}"];
    };
  };
}
