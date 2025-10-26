{lib, ...}: let
  inherit (lib) mkDefault;
in {
  config = {
    services.openssh = {
      enable = mkDefault false;
      settings = {
        LogLevel = "VERBOSE";
        UsePAM = false;
        PasswordAuthentication = false;
        PermitRootLogin = "no";
        X11Forwarding = false;
        extraConfig = ''
          AllowTcpForwarding no
          AllowAgentForwarding no
        '';
      };
    };
  };
}
