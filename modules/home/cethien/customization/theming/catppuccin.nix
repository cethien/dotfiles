{ lib, config, ... }:

{
  options.user.customization.theming.catppuccin.enable = lib.mkEnableOption "Enable catppuccin theme";

  config = lib.mkIf config.user.customization.theming.catppuccin.enable {
    catppuccin.enable = true;
  };
}
