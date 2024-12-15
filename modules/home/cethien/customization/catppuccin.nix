{ lib, config, ... }:

{
  options.user.customization.catppuccin.enable = lib.mkEnableOption "Enable catppuccin theme";

  config = lib.mkIf config.user.customization.catppuccin.enable {
    catppuccin.enable = true;
  };
}
