{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.programs.prismlauncher;
  ws = config.wayland.windowManager.hyprland.defaultWorkspaces.gaming;
in {
  options.programs.prismlauncher.enable = mkEnableOption "prism launcher";

  config = mkIf cfg.enable {
    home.packages = [
      (pkgs.prismlauncher.override {
        jdks = with pkgs; [
          zulu
          zulu17
          zulu8
        ];
        additionalLibs = with pkgs; [
          glfw3-minecraft
          libGL
          libpulseaudio
        ];
      })
    ];

    wayland.windowManager.hyprland.settings.windowrulev2 = [
      "workspace ${toString ws}, class:^(Minecraft.*)$"
      "fullscreen, class:^(Minecraft.*)$"
      "immediate, class:^(Minecraft.*)$"
    ];
  };
}
