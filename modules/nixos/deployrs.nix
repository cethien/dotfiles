{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption mkOption types;
  cfg = config.deeznuts.deployrs;
  enabled = cfg.enable;
in {
  options.deeznuts.deployrs = {
    enable = mkEnableOption "Enable deployrs";
    user = {
      passwordHash = mkOption {
        type = types.str;
        default = null;
        description = "hashed password for user";
      };
      keys = mkOption {
        type = types.listOf types.str;
        default = [];
        description = "ssh public keys";
      };
    };
  };

  config = let
    user = "deployrs";
  in
    mkIf enabled {
      users.users."${user}" = {
        isSystemUser = true;
        group = "${user}";
        extraGroups = ["wheel"];
        createHome = true;
        home = "/var/lib/${user}";
        shell = pkgs.bashInteractive;

        hashedPassword = cfg.user.passwordHash;
        openssh.authorizedKeys.keys = cfg.user.keys;
      };
      users.groups."${user}" = {};

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
