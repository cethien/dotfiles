{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) elem mkIf;

  name = "${config.home.username}";
  shared = import ./firefox-profile.nix {inherit config lib pkgs name;};
  firefoxProfile = lib.recursiveUpdate shared.profiles."${name}" {
    settings = {
      # "extensions.pocket.enabled" = false;
      # "browser.toolbarbuttons.introduced.pocket-button" = false;
      # "browser.toolbarbuttons.introduced.sidebar-button" = true;
      # "browser.toolbars.bookmarks.visibility" = "never";
      # "sidebar.main.tools" = "bookmarks,history";
      # "sidebar.new-sidebar.has-used" = true;
      # "sidebar.revamp" = true;
      # "sidebar.verticalTabs" = true;
      # "widget.disable-workspace-management" = true;
      # "browser.uiCustomization.horizontalTabstrip" = ''["tabbrowser-tabs","new-tab-button"]'';
    };
    extensions.force = true;
  };

  as = elem "firefox" config.wayland.windowManager.hyprland.autostart;
  ws = config.wayland.windowManager.hyprland.defaultWorkspaces.browser;
in {
  config = mkIf config.programs.firefox.enable {
    programs.firefox = {
      inherit (shared) languagePacks nativeMessagingHosts;
      profiles."${name}" = firefoxProfile;
    };

    stylix.targets.firefox.profileNames = ["${name}"];

    wayland.windowManager.hyprland.settings = {
      exec-once = mkIf as ["[silent] firefox"];
      windowrule = mkIf (!isNull ws) ["match:initial_class ^(firefox)$, workspace ${toString ws}"];
    };
  };
}
