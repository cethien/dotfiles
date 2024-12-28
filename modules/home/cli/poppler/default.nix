{ lib, config, pkgs, ... }:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.deeznuts.cli.poppler;
in
{
  options.deeznuts.cli.poppler = {
    enable = mkEnableOption "Enable poppler CLI tools";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ poppler_utils ];
  };
}
