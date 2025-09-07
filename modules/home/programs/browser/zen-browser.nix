{
  lib,
  config,
  pkgs,
  zen-browser,
  ...
}: let
  inherit (lib) mkEnableOption mkOption types mkIf;
  cfg = config.deeznuts.programs.browser.zen-browser;

  name = "${config.home.username}";
  shared = import ./firefox-profile.nix {inherit config lib pkgs name;};
in {
  imports = [
    zen-browser.homeModules.beta
  ];

  options.deeznuts.programs.browser.zen-browser = {
    enable = mkEnableOption "zen browser";
    hyprland = {
      workspace = mkOption {
        type = types.int;
        default = config.deeznuts.desktop.hyprland.defaultWorkspaces.browser;
        description = "default workspace";
      };
      autostart.enable = mkEnableOption "autostart";
    };
  };

  config = mkIf cfg.enable {
    programs.zen-browser.enable = true;
    programs.zen-browser = {
      inherit (shared) languagePacks nativeMessagingHosts;
      profiles."${name}" = shared.profiles."${name}";
    };

    stylix.targets.zen-browser.profileNames = ["${name}"];

    wayland.windowManager.hyprland.settings = {
      exec-once = mkIf cfg.hyprland.autostart.enable [
        "[silent] zen-beta"
      ];
      windowrulev2 = [
        "workspace ${toString cfg.hyprland.workspace}, class:^(zen-beta)$"
      ];
    };
  };
}
