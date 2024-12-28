{ lib, config, ... }:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.deeznuts.apps.terminals.wezterm;
in
{
  options.deeznuts.apps.terminals.wezterm = {
    enable = mkEnableOption "Enable wezterm";
  };

  config = mkIf cfg.enable {
    programs.wezterm.enable = true;
    home.file.".wezterm.lua".source = ./wezterm.lua;
  };
}
