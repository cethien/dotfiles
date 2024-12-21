{ lib, config, pkgs, ... }:

{
  options.cli.poppler.enable = lib.mkEnableOption "Enable poppler";

  config = lib.mkIf config.cli.poppler.enable {
    home.packages = with pkgs; [ poppler_utils ];
  };
}
