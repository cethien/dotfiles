{ lib, config, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.deeznuts.programs.prismlauncher;
in

{
  options.deeznuts.programs.prismlauncher = {
    enable = mkEnableOption "Enable prism-launcher";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ prismlauncher ];
  };
}
