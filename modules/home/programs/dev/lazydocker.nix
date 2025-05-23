{ lib, config, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.deeznuts.programs.lazydocker;
in
{
  options.deeznuts.programs.lazydocker = {
    enable = mkEnableOption "Enable lazydocker";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ lazydocker ];
    home.shellAliases.ldocker = "lazydocker";
  };
}
