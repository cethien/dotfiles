{ lib, config, ... }:

{
  options.virtualizing.docker = {
    enable = lib.mkEnableOption "Enable docker";

    users = lib.mkOption {
      type = with lib.types; listOf (passwdEntry str);
      default = [ ];
      description = "List of users that can use docker";
    };
  };

  config = lib.mkIf config.virtualizing.docker.enable {
    virtualisation.docker.enable = true;
    users.extraGroups.docker.members = config.virtualizing.docker.users;
  };
}
