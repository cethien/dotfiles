{lib, ...}: let
  inherit (lib) mkDefault;
in {
  config = {
    services.openssh = {
      enable = mkDefault false;
      settings = {
        LogLevel = "VERBOSE";

        PermitRootLogin = "no";
        UsePAM = false;
        PasswordAuthentication = false;

        X11Forwarding = false;
        AllowTcpForwarding = "no";
        AllowAgentForwarding = "no";
      };
    };
  };
}
