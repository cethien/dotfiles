{ lib, config, pkgs, ... }:

{
    options.user.gaming.prism-launcher.enable = lib.mkEnableOption "Enable prism-launcher";

    config = lib.mkIf config.user.gaming.prism-launcher.enable {
        home.packages = with pkgs; [ prismlauncher ];
    };
}