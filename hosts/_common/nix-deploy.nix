{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.nix-deploy;
  user = "nix-deploy";
  id = 800;
in {
  options.nix-deploy = {
    enable = mkEnableOption "Enable the dedicated nix-deploy automation user";
  };

  config = mkIf cfg.enable {
    users.groups."${user}".gid = id;

    users.users."${user}" = {
      isSystemUser = true;
      uid = id;
      group = user;
      extraGroups = ["wheel"];
      createHome = true;
      home = "/var/lib/${user}";
      shell = pkgs.bash;
      hashedPassword = "*";
      openssh.authorizedKeys.keys = [
        "no-port-forwarding,no-X11-forwarding,no-agent-forwarding,no-pty ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC5zRzC541CDplODfOhYkTvInDnV4Muoh4KvASD5GQFR nix-deploy@holzrussen.net"
      ];
    };

    security.sudo.extraRules = [
      {
        users = [user];
        commands = [
          {
            command = "ALL";
            options = ["NOPASSWD"];
          }
        ];
      }
    ];
  };
}
