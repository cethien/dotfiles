{ lib, config, ... }:
{
  options.services.ssh.enable = lib.mkEnableOption "Enable SSH Server";

  config = lib.mkIf config.services.ssh.enable {
    services.openssh = {
      enable = true;

      settings = {
        PasswordAuthentication = false;
        PermitRootLogin = "no";
      };
    };

    users.users."cethien".openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKgrZmsUHZn7BAGAl83RUkNejlhJbmLr3lklrlVzy2Zz borislaw.sotnikow@gmx.de"
    ];
  };
}
