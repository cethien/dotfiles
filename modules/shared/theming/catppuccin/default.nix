{ lib, config, ... }:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.deeznuts.theming.catppuccin;
in
{
  options.deeznuts.theming.catppuccin = {
    enable = mkEnableOption "Enable catppuccin";
  };

  config = mkIf cfg.enable {
    catppuccin = {
      enable = true;
      flavor = "mocha";
      accent = "mauve";
    };
  };
}
