{ lib, config, ... }:
{
  options.deeznuts.services.ssh.enable = lib.mkEnableOption "Enable SSH Server";

  config = lib.mkIf config.deeznuts.services.ssh.enable {
    services.openssh = {
      enable = true;

      settings = {
        PasswordAuthentication = false;
        PermitRootLogin = "no";
      };
    };
  };
}
