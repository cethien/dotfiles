{ lib, config, ... }:

{
  options.theming.catppuccin.enable = lib.mkEnableOption "Enable catppuccin module theming";
  config = lib.mkIf config.theming.catppuccin.enable {
    catppuccin = {
      enable = true;
      flavor = "mocha";
      accent = "mauve";
    };
  };
}
