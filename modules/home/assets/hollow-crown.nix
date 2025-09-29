{config, ...}: {
  services.syncthing.settings.folders.hollow-crown = {
    id = "hollow-crown";
    path = "${config.home.homeDirectory}/hollow-crown";
    devices = ["hp-430-g7" "xiaomi-15"];
  };
}
