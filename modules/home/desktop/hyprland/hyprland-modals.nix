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
      bind = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
      };
      terminal = lib.mkOption {
        type = lib.types.bool;
        default = true;
      };
    };
  });

  getExecCommand = m:
    if m.terminal
    then "${pkgs.kitty}/bin/kitty --class ${m.class} -e ${m.exec}"
    else m.exec;

  makeWorkspaces =
    lib.mapAttrsToList (
      name: m: "special:${name}, on-created-empty:${getExecCommand m}, gapsin:0, gapsout:100 200 100 200"
    )
    cfg;

  makeBinds = lib.mapAttrsToList (
    name: m: "${m.bind}, togglespecialworkspace, ${name}"
  ) (lib.filterAttrs (name: m: m.bind != null) cfg);
in {
  options.wayland.windowManager.hyprland.modals = lib.mkOption {
    type = lib.types.attrsOf modalSubmodule;
    default = {};
    description = "Deklarative Overlay-Modals für Hyprland";
  };

  config = lib.mkIf (cfg != {}) {
    wayland.windowManager.hyprland.settings = {
      workspace = makeWorkspaces;
      bind = makeBinds;
    };
  };
}
