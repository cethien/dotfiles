{pkgs-unstable, ...}: {
  programs.qalculate = {
    enable = true;
    package = pkgs-unstable.libqalculate;

    settings = {
      General = {
        colorize = 1;
        precision = 10;
        save_definitions_on_exit = 0;
        save_mode_on_exit = 1;
      };
      Mode = {
        auto_update_exchange_rates = 0;
        angle_unit = 1;
        calculate_as_you_type = 1;
        max_deci = -1;
        min_deci = 0;
        number_base = 10;
      };
    };
  };

  systemd.user.services.qalc-update-rates = {
    Unit = {
      Description = "Update qalc exchange rates";
      After = ["network-online.target"];
      Wants = ["network-online.target"];
    };
    Service = {
      Type = "oneshot";
      ExecStart = "${pkgs-unstable.libqalculate}/bin/qalc -exrates";
    };
  };

  systemd.user.timers.qalc-update-rates = {
    Unit = {
      Description = "Daily update of qalc exchange rates";
    };
    Timer = {
      OnCalendar = "daily";
      Persistent = true;
    };
    Install = {
      WantedBy = ["timers.target"];
    };
  };
}
