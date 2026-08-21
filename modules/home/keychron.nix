{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.programs.keychron;
in {
  options.programs.keychron.enable = lib.mkEnableOption "keychron stuff";

  config = lib.mkIf cfg.enable {
    xdg.desktopEntries."keychron-launcher" = {
      name = "Keychron Launcher";
      genericName = "Keyboard configuration";
      exec = "${pkgs.ungoogled-chromium}/bin/chromium --app=https://launcher.keychron.com/ --password-store=basic";
      icon = "keychron";
      type = "Application";
      categories = ["Utility"];
    };
  };
}
