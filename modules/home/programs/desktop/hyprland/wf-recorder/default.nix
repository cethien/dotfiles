{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.deeznuts.programs.wf-recorder;
  enabled = cfg.enable;
in {
  options.deeznuts.programs.wf-recorder = {
    enable = mkEnableOption "wf-recorder";
  };

  config = mkIf enabled {
    home.packages = with pkgs; [
      wf-recorder
      (writeShellScriptBin "wf-toggle-record" (builtins.readFile ./wf-toggle-record.sh))
    ];

    wayland.windowManager.hyprland.settings = {
      bind = [
        "SUPER SHIFT, R, exec, wf-toggle-record"
      ];
    };
  };
}
