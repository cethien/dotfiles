{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkOption types;
  userWorkspaces = config.deeznuts.hyprland.defaultWorkspaces or {};

  hyprland = {
    getWorkspace = name: userWorkspaces.${name} or null;

    mkWorkspaceRules = wsName: matches: let
      ws = hyprland.getWorkspace wsName;
    in
      if ws == null
      then []
      else
        builtins.concatMap (match: [
          "workspace ${toString ws}, ${match}"
        ])
        matches;

    mkGameWindowRules = matches: let
      gamingWorkspace = hyprland.getWorkspace "gaming";
    in
      if gamingWorkspace == null
      then []
      else
        builtins.concatMap (match: [
          "workspace ${toString gamingWorkspace}, content game, ${match}"
        ])
        matches;
  };
in {
  options.deeznuts.hyprland = {
    defaultWorkspaces = mkOption {
      type = types.attrsOf types.int;
      default = {};
      description = "named workspaces";
    };
  };

  config.lib.deeznuts = {inherit hyprland;};
}
