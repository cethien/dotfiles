{ lib, config, ... }:

{
  options.virtualizing.docker = {
    enable = lib.mkEnableOption "Enable docker";
    liveRestore = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable live restore";
    };

    users = lib.mkOption {
      type = with lib.types; listOf (passwdEntry str);
      default = [ ];
      description = "List of users that can use docker";
    };
  };

  config = lib.mkIf config.virtualizing.docker.enable {
    virtualisation.docker.enable = true;
    virtualisation.docker.liveRestore = config.virtualizing.docker.liveRestore;
    users.extraGroups.docker.members = config.virtualizing.docker.users;
  };
}
