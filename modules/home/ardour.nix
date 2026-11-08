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

  renoiseWrapped = pkgs.writeShellScriptBin "renoise" ''
    export VST3_PATH="$HOME/.nix-profile/lib/vst3:/run/current-system/sw/lib/vst3"
    exec ${pkgs.pipewire.jack}/bin/pw-jack ${pkgs-unstable.renoise}/bin/renoise "$@"
  '';
in {
  options.programs.ardour.enable = mkEnableOption "enable ardour";

  options.programs.renoise.enable = mkEnableOption "enable renoise";

  config = mkIf dawEnabled {
    home.packages =
      []
      ++ optionals cfg.renoise.enable [renoiseWrapped]
      ++ optionals cfg.ardour.enable [pkgs-unstable.ardour]
      ++ optionals dawEnabled (with pkgs-unstable; [
        vital
      ]);

    xdg.desktopEntries.renoise = mkIf cfg.renoise.enable {
      name = "Renoise";
      genericName = "Music Sequencer";
      exec = "renoise %F";
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

          hl.window_rule({
              match = {
                  class = "^(Renoise)$",
                  title = "^(Vital|.*Plugin.*)",
              },
              float = true,
              center = true,
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
