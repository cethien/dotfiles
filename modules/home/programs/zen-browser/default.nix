{ lib, config, inputs, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.deeznuts.programs.zen-browser;
  enabled = cfg.enable;
in
{
  imports = [
    ./hyprland.nix
  ];

  options.deeznuts.programs.zen-browser = {
    enable = mkEnableOption "zen browser";
  };

  config = mkIf enabled {
    home.packages = [
      inputs.zen-browser.packages."x86_64-linux".beta
    ];

    xdg.mimeApps.defaultApplications = {
      # Web / browser-related
      "x-scheme-handler/http" = [ "zen-beta.desktop" ];
      "x-scheme-handler/https" = [ "zen-beta.desktop" ];
      "x-scheme-handler/about" = [ "zen-beta.desktop" ];
      "x-scheme-handler/unknown" = [ "zen-beta.desktop" ];
      "text/html" = [ "zen-beta.desktop" ];
      "application/xhtml+xml" = [ "zen-beta.desktop" ];
    };
  };
}
