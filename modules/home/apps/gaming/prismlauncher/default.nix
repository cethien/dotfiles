{ lib, config, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.deeznuts.apps.gaming.prismlauncher;
in

{
  options.deeznuts.apps.gaming.prismlauncher = {
    enable = mkEnableOption "Enable prism-launcher";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ prismlauncher ];
  };
}
