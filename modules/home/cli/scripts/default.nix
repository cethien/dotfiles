{ lib, config, meta, ... }:

{
  options.deeznuts.cli.scripts.enable = lib.mkEnableOption "Enable scripts";

  config = lib.mkIf config.deeznuts.cli.scripts.enable {
    home.file = {
      "scripts/init.sh".source = ./init.sh;
      "scripts/update.sh".source = ./update.sh;
      "scripts/cleanup.sh".source = ./cleanup.sh;
      "scripts/rebuild.sh".source = ./rebuild.sh;
    };

    home.shellAliases = {
      rebuild = "~/scripts/rebuild.sh -c ${meta.configName}";
      rebuild-nixos = "~/scripts/rebuild.sh -nc ${meta.hostname}";
      init = "~/scripts/init.sh";
      update = "~/scripts/update.sh";
      cleanup = "~/scripts/cleanup.sh";
    };
  };
}
