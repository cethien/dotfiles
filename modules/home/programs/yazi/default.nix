{ lib, config, ... }:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.deeznuts.programs.yazi;
in
{
  imports = [
    ./hyprland.nix
  ];

  options.deeznuts.programs.yazi = {
    enable = mkEnableOption "Enable yazi";
  };

  config = mkIf cfg.enable {
    programs.yazi.enable = true;
  };
}
