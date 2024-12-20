{ lib, config, ... }:

{
  options.desktop.theming.enable = lib.mkEnableOption "Enable theming";

  config = lib.mkIf config.desktop.theming.enable {
    catppuccin.enable = true;
  };
}
