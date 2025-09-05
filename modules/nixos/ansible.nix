{
  lib,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.deeznuts.ansible;
in {
  options.deeznuts.ansible = {
    enable = mkEnableOption "ansible";
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
    user = "ansible";
  in
    mkIf cfg.enable {
      users.users."${user}" = {
        isSystemUser = true;
        group = "${user}";
        extraGroups = mkMerge [
          ["wheel"]
          (mkIf config.virtualisation.docker.enable ["docker"])
        ];
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

      environment.systemPackages = with pkgs; [
        (python3.withPackages (ps: [
          ps.requests
        ]))
      ];
    };
}
