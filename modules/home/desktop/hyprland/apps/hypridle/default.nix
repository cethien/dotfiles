{ lib, config, ... }:
let
  inherit (lib) mkIf mkEnableOption mkOption;
  inherit (lib.types) int;
  cfg = config.deeznuts.desktop.hyprland.idle;
in
{
  options.deeznuts.desktop.hyprland.idle = {
    enable = mkEnableOption "Enable hypridle";

    dimScreen = {
      enable = mkEnableOption "Dim screen on idle";
      timeout = mkOption {
        type = int;
        default = 150; # 2.5 minutes
        description = "Timeout in seconds before dimming the screen";
      };
    };
    lockScreen = {
      enable = mkEnableOption "Lock screen on idle";
      timeout = mkOption {
        type = int;
        default = 300; # 5 minutes
        description = "Timeout in seconds before locking the screen";
      };
    };
    turnOffScreen = {
      enable = mkEnableOption "Turn off screen on idle";
      timeout = mkOption {
        type = int;
        default = 330; # 5.5 minutes
        description = "Timeout in seconds before turning off the screen";
      };
    };
    suspendComputer = {
      enable = mkEnableOption "Suspend computer on idle";
      timeout = mkOption {
        type = int;
        default = 900; # 15 minutes
        description = "Timeout in seconds before suspending the computer";
      };
    };
  };

  config = mkIf cfg.enable {
    services.hypridle = {
      enable = true;

      settings = {
        general = {
          lock_cmd = "pidof hyprlock || hyprlock";
          before_sleep_cmd = "loginctl lock-session";
          after_sleep_cmd = "hyprctl dispatch dpms on";
        };

        listener = [
          (mkIf cfg.dimScreen.enable {
            timeout = cfg.dimScreen.timeout;
            on-timeout = "brightnessctl -s set 10";
            on-resume = "brightnessctl -r";
          })
          (mkIf cfg.lockScreen.enable {
            timeout = cfg.lockScreen.timeout;
            on-timeout = "loginctl lock-session";
          })
          (mkIf cfg.turnOffScreen.enable {
            timeout = cfg.turnOffScreen.timeout;
            on-timeout = "hyprctl dispatch dpms off";
            on-resume = "hyprctl dispatch dpms on";
          })
          (mkIf cfg.suspendComputer.enable {
            timeout = cfg.suspendComputer.timeout;
            on-timeout = "systemctl suspend";
          })
        ];
      };
    };

    wayland.windowManager.hyprland.settings = {
      exec-once = [
        "hypridle"
      ];
    };
  };
}
