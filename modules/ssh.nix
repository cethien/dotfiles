{ user, ... }:
{
  services.openssh = {
    enable = true;

    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
    };
  };

  users.users."${user.username}".openssh.authorizedKeys.keys = user.authorizedKeys;
}
