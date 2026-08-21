{
  config,
  lib,
  pkgs,
  pkgs-unstable,
  ...
}: let
  inherit (lib) mkIf mkEnableOption optionals;
  cfg = config.programs;
  dawEnabled = config.programs.renoise.enable || config.programs.ardour.enable;
in {
  options.programs.ardour.enable = mkEnableOption "enable ardour";

  options.programs.renoise.enable = mkEnableOption "enable renoise";

  config = mkIf dawEnabled {
    home.packages =
      []
      ++ optionals cfg.renoise.enable [pkgs-unstable.renoise]
      ++ optionals cfg.ardour.enable [pkgs-unstable.ardour]
      ++ optionals dawEnabled (with pkgs-unstable; [
        vital
      ]);

    xdg.desktopEntries.renoise = mkIf cfg.renoise.enable {
      name = "Renoise";
      genericName = "Music Sequencer";
      exec = "${pkgs.pipewire.jack}/bin/pw-jack renoise %F";
      icon = "renoise";
      type = "Application";
      categories = ["AudioVideo" "Audio"];
      mimeType = ["application/x-renoise-song" "application/x-renoise-instrument"];
    };

    wayland.windowManager.hyprland.extraLuaFiles = {
      "99-renoise" =
        # lua
        ''
          hl.window_rule({
              match = {
                  class = "^(Renoise)$",
              },
              workspace = hl.defaultWorkspace.daw,
          		center = false,
          })
        '';

      "99-ardour" =
        # lua
        ''
          hl.window_rule({
              match = {
                  class = "^(Ardour)$",
              },
              workspace = hl.defaultWorkspace.daw,
          		center = false,
          })
        '';
    };
  };
}
