{ config, lib, pkgs, inputs, ... }:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.deeznuts.programs.zen;
in
{
  imports = [
    ./hyprland.nix
  ];

  options.deeznuts.programs.zen = {
    enable = mkEnableOption "zen browser";
  };

  config = mkIf cfg.enable {
    home.packages = [ inputs.zen-browser.packages.${pkgs.system}.default ];
  };
}
