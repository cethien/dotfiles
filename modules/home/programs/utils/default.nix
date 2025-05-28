{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.deeznuts.programs.utils;
in {
  options.deeznuts.programs.utils = {
    enable = mkEnableOption "common cli utils";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      zip
      unzip
      rar
      # unrar
      p7zip

      ffmpeg
      (writeShellScriptBin "ffmpeg-convert" (builtins.readFile ./ffmpeg-convert.sh))

      poppler_utils
      bc
      lynx
      aria2
      parted

      tealdeer
    ];

    programs.jq.enable = true;
  };
}
