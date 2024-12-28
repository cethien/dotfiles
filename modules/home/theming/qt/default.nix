{ lib, config, ... }:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.deeznuts.theming.qt;
in
{
  options.deeznuts.theming.qt = {
    enable = mkEnableOption "Enable qt theming";
  };

  config = mkIf cfg.enable {
    qt = {
      enable = true;

      style.catppuccin.enable = true;
      style.name = "kvantum";
      platformTheme.name = "kvantum";
    };
  };
}
