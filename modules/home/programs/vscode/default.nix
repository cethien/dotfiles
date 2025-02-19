{ lib, config, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.deeznuts.programs.vscode;
in
{
  options.deeznuts.programs.vscode = {
    enable = mkEnableOption "VSCode and Chromium";
  };

  config = mkIf cfg.enable {
    home.packages = [ pkgs.nerd-fonts.meslo-lg ];
    programs.vscode.enable = true;
    programs.chromium.enable = true;
  };
}
