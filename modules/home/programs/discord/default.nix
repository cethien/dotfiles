{ lib, config, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.deeznuts.programs.discord;
in
{
  imports = [
    ./hyprland.nix
  ];

  options.deeznuts.programs.discord = {
    enable = mkEnableOption "Enable Discord";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      (discord.override {
        withVencord = true;
        # withOpenASAR = true;
      })
    ];
  };
}
