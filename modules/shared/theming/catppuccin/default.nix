{ lib, config, ... }:

{
  options.deeznuts.theming.catppuccin.enable = lib.mkEnableOption "Enable catppuccin module theming";

  config = lib.mkIf config.deeznuts.theming.catppuccin.enable {
    catppuccin = {
      enable = true;
      flavor = "mocha";
      accent = "mauve";
    };
  };
}
