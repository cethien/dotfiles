{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.deeznuts.programs.pavucontrol;
in {
  options.deeznuts.programs.pavucontrol = {
    enable = mkEnableOption "Enable pavucontrol";
  };

  config = mkIf cfg.enable {
    programs.hyprpanel.settings.bar.workspaces.applicationIconMap."org.pulseaudio.pavucontrol" = "";
    home.packages = with pkgs; [pavucontrol];
  };
}
