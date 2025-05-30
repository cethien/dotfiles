{
  services.syncthing.enable = true;
  services.syncthing.settings = {
    options.urAccepted = -1;
    devices."cethien.me" = {
      id = "5MYOAXN-SPEANRU-2QS3XBO-2U4LO5P-MBZWFPI-PH42WNP-5MCYGTG-QGJHZAS";
      addresses = [
        "tcp://sync.cethien.me:22000"
      ];
    };
  };
}
