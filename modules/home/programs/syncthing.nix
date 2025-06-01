{
  services.syncthing.enable = true;
  services.syncthing.settings = {
    options.urAccepted = -1;
    devices."cethien.me" = {
      id = "IMVEBRU-Q35QFHT-HLCNT7F-XKK7THW-3QJETCU-W2KHNZT-PJFOTDZ-MAZ7HAU";
      addresses = [
        "tcp://sync.cethien.me:22000"
      ];
    };
  };
}
