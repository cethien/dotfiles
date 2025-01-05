{ lib, config, ... }:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.deeznuts.programs.scripts;
in
{
  options.deeznuts.programs.scripts = {
    enable = mkEnableOption "Enable scripts";
  };

  config = mkIf cfg.enable {
    home.file = {
      "scripts/init.sh".source = ./init.sh;
      "scripts/update.sh".source = ./update.sh;
      "scripts/cleanup.sh".source = ./cleanup.sh;
      "scripts/rebuild.sh".source = ./rebuild.sh;
    };

    home.shellAliases = {
      rebuild = "~/scripts/rebuild.sh";
      rebuild-nixos = "~/scripts/rebuild.sh -n";
      init = "~/scripts/init.sh";
      update = "~/scripts/update.sh";
      cleanup = "~/scripts/cleanup.sh";
    };
  };
}
