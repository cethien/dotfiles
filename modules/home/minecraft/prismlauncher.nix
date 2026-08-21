{
  lib,
  config,
  pkgs-unstable,
  ...
}: let
  inherit (lib) mkIf;
  cfg = config.programs.prismlauncher;
in {
  config = mkIf cfg.enable {
    programs.prismlauncher = {
      package = pkgs-unstable.prismlauncher.override {
        jdks = with pkgs-unstable; [
          zulu25
          zulu17 # 1.17 - 1.20.4
          zulu8 # < 1.12.2
          zulu # default / fallback
        ];
      };

      settings = {
        Language = "en_US";
        BackgroundCat = "teawie";
        ConsoleMaxLines = 100000;
        WrapperCommand = "gamemoderun";
        MaxMemAlloc = 16384;
        EnableMangoHud = config.programs.mangohud.enable;

        JvmArgs = "-XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC";
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
