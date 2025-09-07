{
  lib,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.deeznuts.programs.dev.vscode;
in {
  options.deeznuts.programs.dev.vscode = {
    enable = mkEnableOption "vscode";
  };

  config = mkIf cfg.enable {
    home.packages = [pkgs.nerd-fonts.meslo-lg];
    programs.vscode.enable = true;
    stylix.targets.vscode.enable = false;
  };
}
