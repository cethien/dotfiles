{
  lib,
  config,
  pkgs,
  zen-browser,
  ...
}: let
  inherit (lib) mkIf elem;
  cfg = config.programs.zen-browser;
  name = "${config.home.username}";
  shared = import ./firefox-profile.nix {inherit config lib pkgs name;};

  as = elem "zen-browser" config.wayland.windowManager.hyprland.autostart;
  ws = config.wayland.windowManager.hyprland.defaultWorkspaces.browser;
in {
  imports = [
    zen-browser.homeModules.beta
  ];

  config = mkIf cfg.enable {
    programs.zen-browser = {
      inherit (shared) languagePacks nativeMessagingHosts;
      profiles."${name}" =
        shared.profiles."${name}"
        // {
          settings.zen = {
            welcome-screen.seen = true;
          };

          spaces."deez_nuts" = {
            id = "cd0b7a9b-bb11-42e8-a10a-52ea6813e6b4";
            position = 1000;
            icon = "🐔";
          };
          spacesForce = true;

          pins = {
            "mail" = {
              id = "15ce18f1-558d-48c7-955f-36abd3c8e6f3";
              url = "https://mail.google.com/";
              position = 100;
              isEssential = true;
            };
            "home" = {
              id = "98a6cec4-05e5-4803-98f0-2b9684ce847c";
              url = "https://cethien.home/";
              position = 101;
              isEssential = true;
            };
            "youtube" = {
              id = "568d8db9-6d86-401c-bc9f-0abf6df1f551";
              url = "https://youtube.com/";
              position = 200;
            };
          };
          pinsForce = true;
        };
    };

    stylix.targets.zen-browser.profileNames = ["${name}"];

    wayland.windowManager.hyprland.settings = {
      exec-once = mkIf as ["[silent] zen-beta"];
      windowrule = ["match:initial_class ^(zen-beta)$, workspace ${toString ws}"];
    };
  };
}
