{ lib, config, pkgs, ... }:

{
  options.gaming.prism-launcher.enable = lib.mkEnableOption "Enable prism-launcher";

  config = lib.mkIf config.gaming.prism-launcher.enable {
    home.packages = with pkgs; [ prismlauncher ];
  };
}
