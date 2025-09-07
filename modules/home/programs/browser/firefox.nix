{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkOption types mkIf;
  cfg = config.deeznuts.programs.browser.firefox;

  name = "${config.home.username}";
  shared = import ./firefox-profile.nix {inherit config lib pkgs name;};
  firefoxProfile = lib.recursiveUpdate shared.profiles."${name}" {
    settings = {
      "extensions.pocket.enabled" = false;
      "browser.toolbarbuttons.introduced.pocket-button" = false;
      "browser.toolbarbuttons.introduced.sidebar-button" = true;
      "browser.toolbars.bookmarks.visibility" = "never";
      "sidebar.main.tools" = "bookmarks,history";
      "sidebar.new-sidebar.has-used" = true;
      "sidebar.revamp" = true;
      "sidebar.verticalTabs" = true;
      "widget.disable-workspace-management" = true;
      "browser.uiCustomization.horizontalTabstrip" = ''["tabbrowser-tabs","new-tab-button"]'';
    };
    extensions.force = true;
  };
in {
  options.deeznuts.programs.browser.firefox = {
    enable = mkEnableOption "firefox";
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
    programs.firefox.enable = true;
    programs.firefox = {
      inherit (shared) languagePacks nativeMessagingHosts;
      profiles."${name}" = firefoxProfile;
    };

    stylix.targets.firefox.profileNames = ["${name}"];

    wayland.windowManager.hyprland.settings = {
      exec-once = mkIf cfg.hyprland.autostart.enable [
        "[silent] firefox"
      ];
      windowrulev2 = [
        "workspace ${toString cfg.hyprland.workspace}, class:^(firefox)$"
      ];
    };
  };
}
