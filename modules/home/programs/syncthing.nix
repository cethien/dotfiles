{
  services.syncthing.enable = true;
  services.syncthing.settings = {
    options.urAccepted = -1;
    devices = {
      "xiaomi-15" = {
        id = "RA74I3V-6MMZBHA-A6I7XCH-7HGDYPF-WDFNPZX-2WOO3OS-267B4MY-HL7VJA5";
      };
      # "cethien.me" = {
      #   id = "IMVEBRU-Q35QFHT-HLCNT7F-XKK7THW-3QJETCU-W2KHNZT-PJFOTDZ-MAZ7HAU";
      #   addresses = [
      #     "tcp://sync.cethien.me:22000"
      #   ];
      # };
    };
  };
}
