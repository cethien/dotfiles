{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.deeznuts.programs.syncthing;
in {
  options.deeznuts.programs.syncthing.enable = mkEnableOption "syncthing";

  config = mkIf cfg.enable {
    services.syncthing = {
      enable = true;
      settings = {
        options.urAccepted = -1;
        devices = {
          "hp-430-g7" = {
            id = "QQAPR6F-HZE4V4M-JTSTNLO-6SBXQFY-FTEH4ZQ-QDBFFXX-SL5SQOM-LD5XXQU";
          };
          "xiaomi-15" = {
            id = "RA74I3V-6MMZBHA-A6I7XCH-7HGDYPF-WDFNPZX-2WOO3OS-267B4MY-HL7VJA5";
          };
        };
      };
    };
  };
}
