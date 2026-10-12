{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  cfg = config.services.tailscale;
in {
  config = mkIf cfg.enable {
    systemd.services.tailscale-shutdown = {
      stopIfChanged = false;
      restartIfChanged = false;

      description = "tailscale shutdown";
      after = ["tailscaled.service" "tailscaled.socket"];
      requires = ["tailscaled.service"];

      before = ["shutdown.target" "reboot.target" "halt.target"];
      wantedBy = ["multi-user.target"];

      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart = "${pkgs.coreutils}/bin/true";
        ExecStop = "${pkgs.tailscale}/bin/tailscale down";
      };
    };
  };
}
