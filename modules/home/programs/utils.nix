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

      poppler_utils
      ffmpeg
      bc
      lynx

      parted

      tldr
    ];

    programs.jq.enable = true;
  };
}
