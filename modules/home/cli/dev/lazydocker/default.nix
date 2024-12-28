{ lib, config, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.deeznuts.cli.dev.lazydocker;
in
{
  options.deeznuts.cli.dev.lazydocker = {
    enable = mkEnableOption "Enable lazydocker";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ lazydocker ];
    home.shellAliases.ldocker = "lazydocker";
  };
}
