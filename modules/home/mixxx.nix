{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.programs.mixxx;
in {
  options.programs.mixxx.enable = mkEnableOption "mixxx";

  config = mkIf cfg.enable {
    home.packages = [
      pkgs.mixxx
      pkgs.qlcplus
    ];

    xdg.desktopEntries."org.mixxx.Mixxx" = {
      name = "Mixxx";
      genericName = "Digital DJ Systems";
      exec = "${pkgs.pipewire.jack}/bin/pw-jack mixxx %F";
      icon = "mixxx";
      type = "Application";
      categories = ["AudioVideo" "Audio"];
      mimeType = ["application/x-mixxx-playlist"];
    };
  };
}
