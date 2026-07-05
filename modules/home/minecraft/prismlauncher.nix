{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  cfg = config.programs.prismlauncher;
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
        JavaPath = "${pkgs.zulu25}/bin/java";
        JavaDir = "${pkgs.zulu25}/bin";
        JvmArgs = "-XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200";
      };

      package = pkgs.prismlauncher.override {
        jdks = with pkgs; [
          zulu
          zulu25
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

    wayland.windowManager.hyprland.extraLuaFiles = {
      "99-prismlauncher" =
        #lua
        ''
          hl.window_rule({
              match = { class = "^(.*PrismLauncher)$" },
              tile = true,
          })
        '';
    };
  };
}
