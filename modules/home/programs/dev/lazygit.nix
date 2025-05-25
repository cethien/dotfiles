{
  lib,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.deeznuts.programs.lazygit;
in {
  options.deeznuts.programs.lazygit = {
    enable = mkEnableOption "lazygit";
  };

  config = mkIf cfg.enable {
    programs.lazygit.enable = true;
    home.shellAliases.lzg = "lazygit";
  };
}
