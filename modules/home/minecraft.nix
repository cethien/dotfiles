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

    wayland.windowManager.hyprland.extraLuaFiles = {
      "99-minecraft" =
        #lua
        ''
          game_windowrule({ class = "^(Minecraft.*)$" })

          hl.window_rule({
              match = { class = "^(org%.prismlauncher%.PrismLauncher)$" },
              tile = true,
          })
        '';
    };
  };
}
