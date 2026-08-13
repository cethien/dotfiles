{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (config.lib.deeznuts) mkArgcBashBin mkArgcBashBin';
  cfg = config.programs.utils;

  newnote = mkArgcBashBin' ./newnote.sh;
  exec = "${newnote}/bin/newnote";
in {
  options.programs.utils.enable = lib.mkEnableOption "utils";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      newnote
      (mkArgcBashBin' ./init.sh)
      (writeShellScriptBin "update" (builtins.readFile ./update.sh))
      (writeShellScriptBin "cleanup" (builtins.readFile ./cleanup.sh))
      (writeShellScriptBin "clip" (builtins.readFile ./clip.sh))
      (writeShellScriptBin "uln" (builtins.readFile ./uln.sh))
    ];

    xdg.desktopEntries.create-note = {
      name = "newnote";
      inherit exec;
      terminal = true;
      icon = "text-editor";
      categories = ["Utility"];
    };

    programs.tmux.keybindings = [
      {
        key = "n";
        action = "new-window -n newnote ${exec}";
      }
    ];
  };
}
