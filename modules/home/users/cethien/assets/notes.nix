{config, ...}: {
  services.syncthing.settings.folders.notes = {
    id = "notes";
    path = "${config.home.homeDirectory}/notes";
    devices = ["hp-430-g7" "xiaomi-15" "tower-of-power"];
  };
}
