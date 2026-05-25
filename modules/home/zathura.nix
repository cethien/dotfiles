{config, ...}: {
  xdg.mimeApps.defaultApplications = config.lib.deeznuts.mkMimeApps {
    pdf = {
      desktop = "org.pwmt.zathura.desktop";
      types = ["application/pdf"];
    };
  };
}
