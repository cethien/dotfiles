{config, ...}: {
  services.syncthing.enable = true;
  services.syncthing.settings = {
    options = {
      urAccepted = -1;
    };

    folders = {
      passwords = {
        id = "passwords";
        path = "${config.home.homeDirectory}/.pass";
        devices = ["cethien.me"];
      };
    };

    devices."cethien.me" = {
      id = "5MYOAXN-SPEANRU-2QS3XBO-2U4LO5P-MBZWFPI-PH42WNP-5MCYGTG-QGJHZAS";
      addresses = [
        "tcp://sync.cethien.me:22000"
      ];
    };
  };
}
