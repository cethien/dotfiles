{
  lib,
  config,
  ...
}:
with lib; let
  inherit (lib) mkDefault;
in {
  config = mkIf config.wayland.windowManager.hyprland.enable {
    services.hypridle = {
      enable = mkDefault true;

      settings = {
        general = {
          lock_cmd = "pidof hyprlock || hyprlock";
          before_sleep_cmd = "loginctl lock-session";
          after_sleep_cmd = "hyprctl dispatch dpms on";
        };

        listener = [
          {
            timeout = mkDefault 150;
            on-timeout = "systemd-ac-power || brightnessctl -s set 25%";
            on-resume = "brightnessctl -r";
          }
          {
            timeout = mkDefault 300;
            on-timeout = "systemd-ac-power || loginctl lock-session";
          }
          {
            timeout = mkDefault 330;
            on-timeout = "systemd-ac-power || hyprctl dispatch dpms off";
            on-resume = "hyprctl dispatch dpms on";
          }
          {
            timeout = mkDefault 900;
            on-timeout = "systemd-ac-power || systemctl suspend";
          }
        ];
      };
    };
  };
}
