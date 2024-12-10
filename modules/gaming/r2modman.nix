{ lib, config, pkgs, ... }:

{
  options.gaming.r2modman.enable = lib.mkEnableOption "Enable r2modman(Thunderstore Mod Manager)";

  config = lib.mkIf config.gaming.r2modman.enable {
    environment.systemPackages = with pkgs; [
      r2modman
    ];
  };
}
