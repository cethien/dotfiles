{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.services.battery-checker;
  script = pkgs.writeShellScriptBin "battery-checker" (builtins.readFile ./battery-checker.sh);
in {
  options.services.battery-checker = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to enable the custom battery and charger notification watcher.";
    };

    interval = mkOption {
      type = types.str;
      default = "5s";
      description = "How often to trigger the battery status check script.";
    };
  };

  config = mkIf cfg.enable {
    systemd.user.services.battery-checker = {
      Unit = {
        Description = "Single check of battery state and notify via Mako";
        After = ["graphical-session.target"];
      };
      Service = {
        Type = "oneshot";
        ExecStart = "${script}/bin/battery-checker";
        Environment = "PATH=${lib.makeBinPath [pkgs.libnotify pkgs.coreutils pkgs.bash]}";
      };
    };

    systemd.user.timers.battery-checker = {
      Unit = {
        Description = "Trigger battery check at configured intervals";
      };
      Timer = {
        OnCalendar = "";
        OnUnitActiveSec = cfg.interval;
        AccuracySec = "1s";
      };
      Install = {
        WantedBy = ["timers.target"];
      };
    };
  };
}
