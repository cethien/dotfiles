{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (config.lib.deeznuts.argc) mkBashBin mkBashBin';
  cfg = config.programs.utils;

  newnote = mkBashBin {
    src = ./newnote.sh;
    extraRuntimeDeps = [pkgs.gum];
  };
in {
  options.programs.utils.enable = lib.mkEnableOption "utils";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      newnote
      (mkBashBin' ./init.sh)
      (writeShellScriptBin "update" (builtins.readFile ./update.sh))
      (writeShellScriptBin "cleanup" (builtins.readFile ./cleanup.sh))
      (writeShellScriptBin "clip" (builtins.readFile ./clip.sh))
      (writeShellScriptBin "uln" (builtins.readFile ./uln.sh))
    ];

    xdg.desktopEntries.create-note = {
      name = "newnote";
      exec = "${newnote}/bin/newnote";
      terminal = true;
      icon = "text-editor";
      categories = ["Utility"];
    };

    programs.tmux.keybindings = [
      {
        key = "n";
        action = "new-window -n 'newnote' '${newnote}/bin/newnote'";
      }
    ];
  };
}
