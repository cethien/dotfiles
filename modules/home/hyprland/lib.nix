{
  lib,
  config,
  pkgs,
  ...
}: let
  userWorkspaces = config.wayland.windowManager.hyprland.defaultWorkspaces or {};
  l = lib.generators.mkLuaInline;

  hyprland = {
    getWorkspace = name: userWorkspaces.${name} or null;

    mkAutostart = cmd: rules: {
      _args = [
        "hyprland.start"
        (l (
          if rules == {}
          then "function() hl.exec_cmd(\"${cmd}\") end"
          else "function() hl.exec_cmd(\"${cmd}\", ${lib.generators.toLua {} rules}) end"
        ))
      ];
    };

    mkDspBind = key: dspCall: flags: {
      _args =
        [
          key
          (l dspCall)
        ]
        ++ lib.optional (flags != {}) flags;
    };

    mkExecBind = key: cmd: flags:
      hyprland.mkDspBind key "hl.dsp.exec_cmd(\"${cmd}\")" flags;

    mkWindowRule = match: rules: {
      _args = [
        (rules // {inherit match;})
      ];
    };

    mkDefaultWorkspaceWindowRule = wsName: matchAttrs: let
      ws = hyprland.getWorkspace wsName;
    in
      if ws == null
      then {}
      else
        hyprland.mkWindowRule matchAttrs {
          workspace = ws;
        };

    mkGameWindowRules = matchAttrs: let
      ws = hyprland.getWorkspace "gaming";
    in
      if ws == null
      then {}
      else
        hyprland.mkWindowRule matchAttrs {
          workspace = ws;
          content = "game";
        };
  };
in {
  config.lib.deeznuts = {inherit hyprland;};
}
