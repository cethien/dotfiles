{ lib, config, ... }:

{
  options.user.desktop.theming.qt.enable = lib.mkEnableOption "Enable qt theming";

  config = lib.mkIf config.user.desktop.theming.qt.enable {
    qt = {
      enable = true;

      style.catppuccin.enable = true;
      style.name = "kvantum";
      platformTheme.name = "kvantum";
    };
  };
}
