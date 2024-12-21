{ lib, config, pkgs, ... }:

{
  options.apps.gaming.r2modman.enable = lib.mkEnableOption "Enable r2modman(Thunderstore Mod Manager)";

  config = lib.mkIf config.apps.gaming.r2modman.enable {
    home.packages = with pkgs; [ r2modman ];
  };
}
