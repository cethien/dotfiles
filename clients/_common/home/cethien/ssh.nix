{
  # Personal SSH hosts, shared by the home desktop and laptop.
  config = {
    programs.ssh.settings."Host holzrussen.net" = {
      HostName = "10.0.1.2";
      User = "cethien";
      IdentityFile = "~/.ssh/id_ed25519";
      IdentitiesOnly = "yes";
    };
  };
}
