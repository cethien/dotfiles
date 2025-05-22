{ lib, config, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.deeznuts.programs.common-utils;
in
{
  options.deeznuts.programs.common-utils = {
    enable = mkEnableOption "common cli utils";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      curl
      wget

      zip
      unzip
      rar
      # unrar
      p7zip

      parted

      tldr
    ];
  };
}
