{ lib, config, pkgs, ... }:

{
  options.deeznuts.apps.gaming.prismlauncher.enable = lib.mkEnableOption "Enable prism-launcher";

  config = lib.mkIf config.deeznuts.apps.gaming.prismlauncher.enable {
    home.packages = with pkgs; [ prismlauncher ];
  };
}
