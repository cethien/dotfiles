{ lib, config, ... }:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.deeznuts.programs.zathura;
  enabled = cfg.enable;
in
{
  options.deeznuts.programs.zathura = {
    enable = mkEnableOption "zathura";
  };

  config = mkIf enabled {
    programs.zathura = {
      enable = true;
    };

    xdg.mimeApps.defaultApplications = {
      # PDFs
      "application/pdf" = [ "org.pwmt.zathura.desktop" ];
    };
  };
}
