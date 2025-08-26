{
  config,
  lib,
  ...
}:
with lib; {
  home.file = {
    "Pictures/logo.png".source = ./logo.png;
    "Pictures/smiley.png".source = ./smiley.png;
  };

  services.syncthing.settings = mkIf config.services.syncthing.enable {
    folders.hollow-crown = {
      id = "hollow-crown";
      path = "${config.home.homeDirectory}/projects/hollow-crown";
      devices = ["xiaomi-15"];
    };
  };
}
