{
  lib,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.deeznuts.programs.lazydocker;
in {
  options.deeznuts.programs.lazydocker = {
    enable = mkEnableOption "lazydocker";
  };

  config = mkIf cfg.enable {
    programs.lazydocker.enable = true;
    home.shellAliases.lzd = "lazydocker";
  };
}
