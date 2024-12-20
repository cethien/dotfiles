{ ... }:
{
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
}
