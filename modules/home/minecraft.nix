{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  cfg = config.programs.prismlauncher;

  inherit (config.lib.deeznuts.hyprland) mkGameWindowRules mkWindowRule;
in {
  config = mkIf cfg.enable {
    programs.prismlauncher = {
      settings = {
        Language = "en_US";
        BackgroundCat = "teawie";
        ConsoleMaxLines = 100000;
        WrapperCommand = "gamemoderun";
        MaxMemAlloc = 16384;
        EnableMangoHud = config.programs.mangohud.enable;
        JavaPath = "${pkgs.zulu}/bin/java";
        JavaDir = "${pkgs.zulu}/bin";
        JvmArgs = "-XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200";
      };

      package = pkgs.prismlauncher.override {
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
      };
    };

    wayland.windowManager.hyprland.settings.window_rule = [
      (mkGameWindowRules [{class = "^(Minecraft.*)$";}])
      (mkWindowRule {class = "^(org\\.prismlauncher\\.PrismLauncher)$";} {tile = true;})
    ];
  };
}
