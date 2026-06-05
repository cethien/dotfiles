{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.wayland.windowManager.hyprland.modals;

  modalSubmodule = lib.types.submodule ({name, ...}: {
    options = {
      exec = lib.mkOption {
        type = lib.types.str;
        default = name;
      };
      class = lib.mkOption {
        type = lib.types.str;
        default = name;
      };
      binds = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [];
        description = "Liste von Keybinds für diese App";
      };
      terminal = lib.mkOption {
        type = lib.types.bool;
        default = true;
      };
    };
  });

  getExecCommand = m:
    if m.terminal
    then "kitty --class ${m.class} -e ${m.exec}"
    else m.exec;

  mkWorkspaces =
    lib.mapAttrsToList (
      name: m: "special:${name}, on-created-empty:${getExecCommand m}, gapsin:0, gapsout:100 200 100 200"
    )
    cfg;

  mkWindowrules =
    lib.mapAttrsToList (
      name: m: "workspace special:${name} silent, match:class ^(${m.class})$"
    )
    cfg;

  mkBinds = lib.flatten (lib.mapAttrsToList (
      name: m:
        map (bind: "${bind}, togglespecialworkspace, ${name}") m.binds
    )
    cfg);
in {
  options.wayland.windowManager.hyprland.modals = lib.mkOption {
    type = lib.types.attrsOf modalSubmodule;
    default = {};
    description = "overlay modals (special workspace abuse)";
  };

  config = lib.mkIf (cfg != {}) {
    wayland.windowManager.hyprland.settings = {
      windowrule = mkWindowrules;
      workspace = mkWorkspaces;
      bind = mkBinds;
    };
  };
}
