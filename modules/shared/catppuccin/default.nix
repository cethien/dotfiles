{ lib, config, ... }:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.deeznuts.catppuccin;
in
{
  options.deeznuts.catppuccin = {
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
