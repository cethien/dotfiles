{ lib, config, ... }:
let
  inherit (lib) mkIf mkEnableOption mkOption;
  inherit (lib.types) int;
  cfg = config.deeznuts.desktop.hyprland.idle;
  enable = cfg.enable || config.deeznuts.desktop.hyprland.enable;
in
{
  options.deeznuts.desktop.hyprland.idle = {
    enable = mkEnableOption "Enable hypridle";

    dimScreen = {
      timeout = mkOption {
        type = int;
        default = 150; # 2.5 minutes
        description = "Timeout in seconds before dimming the screen";
      };
    };
    lockScreen = {
      timeout = mkOption {
        type = int;
        default = 300; # 5 minutes
        description = "Timeout in seconds before locking the screen";
      };
    };
    turnOffScreen = {
      timeout = mkOption {
        type = int;
        default = 330; # 5.5 minutes
        description = "Timeout in seconds before turning off the screen";
      };
    };
    suspendComputer = {
      timeout = mkOption {
        type = int;
        default = 900; # 15 minutes
        description = "Timeout in seconds before suspending the computer";
      };
    };
  };

  config = mkIf enable {
    services.hypridle = {
      enable = true;

      settings = {
        general = {
          lock_cmd = "pidof hyprlock || hyprlock";
          before_sleep_cmd = "loginctl lock-session";
          after_sleep_cmd = "hyprctl dispatch dpms on";
        };

        listener = [
          {
            timeout = cfg.dimScreen.timeout;
            on-timeout = "brightnessctl -s set 25%";
            on-resume = "brightnessctl -r";
          }
          {
            timeout = cfg.lockScreen.timeout;
            on-timeout = "loginctl lock-session";
          }
          {
            timeout = cfg.turnOffScreen.timeout;
            on-timeout = "hyprctl dispatch dpms off";
            on-resume = "hyprctl dispatch dpms on";
          }
          {
            timeout = cfg.suspendComputer.timeout;
            on-timeout = "systemctl suspend";
          }
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
