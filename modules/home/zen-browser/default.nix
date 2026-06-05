{
  lib,
  config,
  pkgs,
  zen-browser,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.programs.zen-browser;
  uname = "${config.home.username}";

  ws = config.deeznuts.hyprland.defaultWorkspaces.browser;
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
      exec-once = mkIf cfg.autostart ["[silent] zen-beta"];
      windowrule = ["match:class ^(zen-beta)$, tile on"];
      bind = let
        script = pkgs.writeShellScriptBin "hypr_zen-sidebar" ''
          DESIGNATED_WS=${toString ws}
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
        "SUPER, W, exec, ${script}/bin/hypr_zen-sidebar"
        ", XF86HomePage, exec, ${script}/bin/hypr_zen-sidebar"
      ];
    };
  };
}
