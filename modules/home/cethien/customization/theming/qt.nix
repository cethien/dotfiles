{ lib, config, ... }:

{
  options.user.customization.theming.qt.enable = lib.mkEnableOption "Enable qt theming";

  config = lib.mkIf config.user.customization.theming.qt.enable {
    qt = {
      enable = true;

      style.catppuccin.enable = true;
      style.name = "kvantum";
      platformTheme.name = "kvantum";
    };
  };
}
