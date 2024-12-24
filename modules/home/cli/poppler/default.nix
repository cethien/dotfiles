{ lib, config, pkgs, ... }:

{
  options.deeznuts.cli.poppler.enable = lib.mkEnableOption "Enable poppler";

  config = lib.mkIf config.deeznuts.cli.poppler.enable {
    home.packages = with pkgs; [ poppler_utils ];
  };
}
