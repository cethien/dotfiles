{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.deeznuts.programs.pinta;
in {
  options.deeznuts.programs.pinta = {
    enable = mkEnableOption "Enable pinta";
  };

  config = mkIf cfg.enable {
    programs.hyprpanel.settings.bar.workspaces.applicationIconMap."com.github.PintaProject.Pinta" = "󰃣";
    home.packages = with pkgs; [pinta];
  };
}
