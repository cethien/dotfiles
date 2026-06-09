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
        description = "keybinds";
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
      name: m: {
        _args = [
          {
            workspace = "special:${name}";
            on_created_empty = getExecCommand m;
            gaps_in = 0;
            gaps_out = 200;
          }
        ];
      }
    )
    cfg;

  mkWindowrules = let
    inherit (config.lib.deeznuts.hyprland) mkWindowRule;
  in
    lib.mapAttrsToList (
      name: m:
        mkWindowRule {class = "^(${m.class})$";} {workspace = "special:${name} silent";}
    )
    cfg;

  mkBinds = let
    inherit (config.lib.deeznuts.hyprland) mkDspBind;
  in
    lib.flatten (lib.mapAttrsToList (
        name: m:
          map (bind: mkDspBind bind "hl.dsp.workspace.toggle_special('${name}')" {}) m.binds
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
      window_rule = mkWindowrules;
      workspace_rule = mkWorkspaces;
      bind = mkBinds;
    };
  };
}
