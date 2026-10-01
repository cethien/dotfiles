{
  config,
  lib,
  pkgs,
  pkgs-unstable,
  ...
}: let
  inherit (lib) mkIf;
  cfg = config.programs.rbw;
  uname = config.home.username;
in {
  config = mkIf cfg.enable {
    programs.rbw = {
      settings = {
        pinentry = pkgs.pinentry-rofi;
      };
    };

    programs.zen-browser = {
      profiles."${uname}".extensions.packages = with pkgs.firefox-addons; [
        bitwarden
      ];
    };
  };
}
