{
  lib,
  config,
  pkgs,
  zen-browser,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  inherit (config.lib.deeznuts.hyprland) mkWindowRule mkExecBind;

  cfg = config.programs.zen-browser;
  uname = "${config.home.username}";

  ws = config.wayland.windowManager.hyprland.defaultWorkspaces;
in {
  options.programs.zen-browser = {
    autostart = mkEnableOption "zen autostart";
    isDefault = mkEnableOption "set zen as default browser";
  };

  imports = [
    zen-browser.homeModules.beta
  ];

  config = mkIf cfg.enable {
    deeznuts.defaultBrowser = mkIf cfg.isDefault "zen-beta";

    programs.zen-browser = {
      profiles."${uname}" =
        {
          id = 0;
          name = uname;
        }
        // import ./profile-settings.nix {inherit (pkgs) firefox-addons;};

      policies = {
        ImportEnterpriseRoots = true;
        AutofillAddressEnabled = true;
        AutofillCreditCardEnabled = false;
        DisableAppUpdate = true;
        DisableFeedbackCommands = true;
        DisableFirefoxStudies = true;
        DisablePocket = true;
        DisableTelemetry = true;
        DontCheckDefaultBrowser = true;
        # NoDefaultBookmarks = true;
        OfferToSaveLogins = false;
        EnableTrackingProtection = {
          Value = true;
          Locked = true;
          Cryptomining = true;
          Fingerprinting = true;
        };
      };

      languagePacks = [
        "en-US"
        "en-GB"
        "de"
        "ru"
      ];
    };

    stylix.targets.zen-browser.profileNames = ["${uname}"];

    wayland.windowManager.hyprland.settings = {
      window_rule = [
        (mkWindowRule {initial_class = "^(zen-beta)$";} {tile = true;})
        (mkWindowRule {
            initial_class = "^(zen-beta)$";
            initial_title = "^(Picture-in-Picture)$";
          } {
            workspace = ws.pip;
            no_initial_focus = true;
            suppress_event = "activatefocus";
          })
      ];

      bind = let
        s = pkgs.writeShellScriptBin "hypr_zen-sidebar" ''
          DESIGNATED_WS=${toString ws.browser}
          BROWSER_WS=$(hyprctl -j clients \
            | jq -r '.[] | select(.initialClass=="zen-beta") | .workspace.id' \
            | head -n1)

          WS_JSON=$(hyprctl -j activeworkspace)
          ACTIVE_WS=$(echo "$WS_JSON" | jq -r '.id')
          HAS_FULLSCREEN=$(echo "$WS_JSON" | jq -r '.hasfullscreen')

          if [ -z "$BROWSER_WS" ]; then
            zen-beta &
            exit 0
          fi

          if [ -n "$DESIGNATED_WS" ] && [ "$BROWSER_WS" = "$ACTIVE_WS" ] || [ "$HAS_FULLSCREEN" = "true" ]; then
            hyprctl dispatch movetoworkspacesilent $DESIGNATED_WS,initialclass:zen-beta
          else
            hyprctl dispatch movetoworkspace $ACTIVE_WS,initialclass:zen-beta
          fi
        '';
      in [
        (mkExecBind "SUPER + W" "${s}/bin/hypr_zen-sidebar" {})
        (mkExecBind "XF86HomePage" "${s}/bin/hypr_zen-sidebar" {})
      ];
    };
  };
}
