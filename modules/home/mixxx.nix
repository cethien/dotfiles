{
  config,
  lib,
  pkgs,
  pkgs-unstable,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.programs.mixxx;

  mixxxWrapped = pkgs.writeShellScriptBin "mixxx" ''
    exec ${pkgs.pipewire.jack}/bin/pw-jack ${pkgs-unstable.mixxx}/bin/mixxx "$@"
  '';
in {
  options.programs.mixxx.enable = mkEnableOption "mixxx";

  config = mkIf cfg.enable {
    home.packages = [
      mixxxWrapped
      pkgs.qlcplus
    ];

    xdg.desktopEntries."org.mixxx.Mixxx" = {
      name = "Mixxx";
      genericName = "Digital DJ Systems";
      exec = "mixxx %F";
      icon = "mixxx";
      type = "Application";
      categories = ["AudioVideo" "Audio"];
      mimeType = ["application/x-mixxx-playlist"];
    };
  };
}
