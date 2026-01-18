{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkMerge mkIf;
  ws = config.wayland.windowManager.hyprland.defaultWorkspaces.gaming;
  as = builtins.elem "steam" config.wayland.windowManager.hyprland.autostart;
in {
  options.programs.steam.enable = mkEnableOption "steam stuff";

  config = mkIf config.programs.steam.enable {
    xdg.desktopEntries.steam-friends-list = {
      name = "Steam Friends List";
      icon = "steam";
      exec = "xdg-open steam://open/friends";
    };
    wayland.windowManager.hyprland.settings = {
      exec-once = mkIf as ["steam -silent"];
      windowrule = let
        mkGame = match: pkgs.cethien.mkHyprGameWindowRule match "${toString ws}";
      in
        mkMerge [
          (mkGame "match:initial_class ^(steam_app_.*)$, match:initial_title ..*")
          (mkGame "match:initial_class (?i).*\.exe$, match:initial_title ..*")
        ];
    };
  };
}
