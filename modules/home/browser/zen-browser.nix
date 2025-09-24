{
  lib,
  config,
  pkgs,
  inputs,
  ...
}: let
  inherit (lib) mkIf elem;
  cfg = config.programs.zen-browser;
  hypr = elem "zen-browser" config.wayland.windowManager.hyprland.autostart;
  ws = config.wayland.windowManager.hyprland.defaultWorkspaces.browser;

  name = "${config.home.username}";
  shared = import ./firefox-profile.nix {inherit config lib pkgs name;};
in {
  imports = [
    inputs.zen-browser.homeModules.beta
  ];

  config = mkIf cfg.enable {
    programs.zen-browser = {
      inherit (shared) languagePacks nativeMessagingHosts;
      profiles."${name}" = shared.profiles."${name}";
    };

    stylix.targets.zen-browser.profileNames = ["${name}"];

    wayland.windowManager.hyprland.settings = {
      exec-once = mkIf hypr [
        "[silent] zen-beta"
      ];
      windowrulev2 = [
        "workspace ${toString ws}, class:^(zen-beta)$"
      ];
    };
  };
}
