{ lib, config, pkgs, ... }:

{
  options.user.apps.discord.enable = lib.mkEnableOption "Enable Discord";

  config = lib.mkIf config.user.apps.discord.enable {
    home.packages = with pkgs; [
      vesktop
    ];
  };
}
