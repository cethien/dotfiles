{config, ...}: let
  inherit (config.lib.deeznuts) mkMimeApps;
in {
  xdg.mimeApps.defaultApplications = mkMimeApps {
    pdf = {
      desktop = "org.pwmt.zathura.desktop";
      types = ["application/pdf"];
    };
  };
}
