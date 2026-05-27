{
  config,
  pkgs,
  lib,
  ...
}: {
  config = {
    services.openssh.settings = {
      LogLevel = "VERBOSE";

      PermitRootLogin = "no";
      UsePAM = false;
      PasswordAuthentication = false;

      X11Forwarding = false;
      AllowTcpForwarding = "no";
      AllowAgentForwarding = "no";
    };
  };
}
