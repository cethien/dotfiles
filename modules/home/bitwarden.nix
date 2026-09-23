{
  config,
  lib,
  pkgs,
  pkgs-unstable,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.programs.bitwarden;
  uname = config.home.username;
in {
  options.programs.bitwarden.enable = mkEnableOption "bitwarden + rbw stuff";

  config = mkIf cfg.enable {
    home.packages = [pkgs-unstable.bitwarden-desktop];

    programs.rbw = {
      enable = true;
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
