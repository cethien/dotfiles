{ lib, config, pkgs, ... }:

{
  options.deeznuts.apps.discord.enable = lib.mkEnableOption "Enable Discord";

  config = lib.mkIf config.deeznuts.apps.discord.enable {
    home.packages = with pkgs; [
      (discord-canary.override {
        withOpenASAR = true;
        withVencord = true;
      })
    ];
  };
}
