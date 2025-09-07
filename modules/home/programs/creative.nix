{
  lib,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.deeznuts.creative;
in {
  options.deeznuts.creative = {
    enable = mkEnableOption "enable all media creation tools";
    mixxx.enable = mkEnableOption "mixxx";
    ardour.enable = mkEnableOption "ardour";
    obs-studio = {
      enable = mkEnableOption "obs";
      hyprland.workspace = mkOption {
        type = types.int;
        default = 10;
        description = "default hyprland workspace";
      };
    };
  };

  config = mkIf cfg.enable {
    home.packages = mkMerge [
      (with pkgs; [pinta gimp inkscape ocenaudio])
      (mkIf cfg.mixxx.enable [pkgs.mixxx])
      (mkIf cfg.ardour.enable [pkgs.ardour])
    ];

    programs.obs-studio = {
      enable = cfg.obs-studio.enable;

      plugins = with pkgs.obs-studio-plugins; [
        wlrobs
        obs-webkitgtk
        obs-vkcapture
        obs-pipewire-audio-capture
        obs-vaapi

        # advanced-scene-switcher
        # obs-vertical-canvas
        obs-source-switcher
        # obs-source-record
        obs-source-clone
        obs-shaderfilter
        obs-move-transition
        obs-gradient-source
        # obs-command-source

        # obs-composite-blur
        # obs-transition-table
        # obs-backgroundremoval
      ];
    };
    wayland.windowManager.hyprland.settings = {
      windowrulev2 = mkMerge [
        (mkIf cfg.obs-studio.enable [
          "workspace ${toString cfg.obs-studio.hyprland.workspace}, class:^(com\.obsproject\.Studio)$"
        ])
      ];
    };
  };
}
