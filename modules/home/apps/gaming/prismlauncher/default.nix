{ lib, config, pkgs, ... }:

{
  options.apps.gaming.prismlauncher.enable = lib.mkEnableOption "Enable prism-launcher";

  config = lib.mkIf config.apps.gaming.prismlauncher.enable {
    home.packages = with pkgs; [ prismlauncher ];
  };
}
