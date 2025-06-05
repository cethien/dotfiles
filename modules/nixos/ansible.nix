{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption mkOption types;
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

  config = mkIf cfg.enable {
    users.users.ansible = {
      description = "ansible user";
      isNormalUser = true;
      extraGroups =
        ["wheel"]
        ++ (mkIf config.virtualisation.docker.enable [
          "docker"
        ]);
      hashedPassword = cfg.user.passwordHash;
      openssh.authorizedKeys.keys = cfg.user.keys;
    };

    security.sudo.extraRules = [
      {
        users = ["ansible"];
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
