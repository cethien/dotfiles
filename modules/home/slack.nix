{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf elem;
  ws = config.wayland.windowManager.hyprland.defaultWorkspaces.chat;
in {
  options.programs.slack.enable = lib.mkEnableOption "slack";

  config = mkIf config.programs.slack.enable {
    home.packages = [pkgs.slack];
    wayland.windowManager.hyprland.settings = let
      auto = elem "slack" config.wayland.windowManager.hyprland.autostart;
    in {
      exec-once = mkIf auto ["[silent] slack -u"];
      windowrule = mkIf (!isNull ws) ["match:initial_class Slack, workspace ${toString ws}"];
    };
  };
}
