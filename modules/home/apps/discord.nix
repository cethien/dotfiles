{ lib, config, pkgs, ... }:

{
  options.apps.discord.enable = lib.mkEnableOption "Enable Discord";

  config = lib.mkIf config.apps.discord.enable {
    home.packages = with pkgs; [
      (discord-canary.override {
        withOpenASAR = true;
        withVencord = true;
      })
    ];
  };
}
