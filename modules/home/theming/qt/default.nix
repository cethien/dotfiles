{ lib, config, ... }:

{
  options.theming.qt.enable = lib.mkEnableOption "Enable qt theming";

  config = lib.mkIf config.theming.qt.enable {
    qt = {
      enable = true;

      style.catppuccin.enable = true;
      style.name = "kvantum";
      platformTheme.name = "kvantum";
    };
  };
}
