{ lib, config, pkgs, ... }:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.deeznuts.programs.poppler;
in
{
  options.deeznuts.programs.poppler = {
    enable = mkEnableOption "Enable poppler CLI tools";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ poppler_utils ];
  };
}
