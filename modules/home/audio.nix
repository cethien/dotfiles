{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.deeznuts.audio;
in {
  options.deeznuts.audio = {
    enable = mkEnableOption "audio related programs";
  };

  config = mkIf cfg.enable {
    services.easyeffects.enable = true;
    programs.hyprpanel.settings.bar.workspaces.applicationIconMap."org.pulseaudio.pavucontrol" = "";
    home.packages = with pkgs; [
      pavucontrol
      qpwgraph
    ];
  };
}
