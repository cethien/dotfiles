{ lib, config, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.deeznuts.programs.zip;
in
{
  options.deeznuts.programs.zip = {
    enable = mkEnableOption "zip";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      zip
      unzip
      rar
      # unrar
      p7zip
    ];
  };
}
