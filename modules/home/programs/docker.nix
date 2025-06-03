{
  lib,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.deeznuts.programs.docker;
in {
  options.deeznuts.programs.docker = {
    enable = mkEnableOption "docker tools (home-manager can't install docker)";
  };

  config = mkIf cfg.enable {
    programs.lazydocker.enable = true;
    home.shellAliases.lzd = "lazydocker";
  };
}
