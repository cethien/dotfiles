{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (config.lib.deeznuts) mkArgcBashBin mkArgcBashBin';
  cfg = config.programs.utils;

  newnote = mkArgcBashBin' ./newnote.sh;
  execNewnote = "${newnote}/bin/newnote";

  update = mkArgcBashBin {
    src = ./update.sh;
    extraRuntimeDeps = [pkgs.nvd];
  };
  execUpdate = "${update}/bin/update";
in {
  options.programs.utils.enable = lib.mkEnableOption "utils";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      newnote
      update
      (mkArgcBashBin' ./init.sh)
      (writeShellScriptBin "cleanup" (builtins.readFile ./cleanup.sh))
      (writeShellScriptBin "clip" (builtins.readFile ./clip.sh))
      (writeShellScriptBin "uln" (builtins.readFile ./uln.sh))
    ];

    xdg.desktopEntries = {
      create-note = {
        name = "newnote";
        exec = execNewnote;
        terminal = true;
        icon = "text-editor";
        categories = ["Utility"];
      };

      system-update = {
        name = "System Update";
        comment = "Update NixOS or system packages";
        exec = "sudo ${execUpdate}";
        terminal = true;
        icon = "system-software-update";
        categories = ["System" "Settings"];
      };
    };

    programs.tmux.keybindings = [
      {
        key = "n";
        action = "new-window -an newnote ${execNewnote}";
      }
      {
        key = "u";
        action = "new-window -an update sudo ${execUpdate}";
      }
    ];
  };
}
