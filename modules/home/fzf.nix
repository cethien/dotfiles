{
  lib,
  config,
  pkgs,
  ...
}: let
in {
  config.programs.fzf = {
    defaultCommand = "fd --type f";
    defaultOptions = ["--preview-window=bottom:70%" "--layout=reverse"];

    fileWidget = {
      command = "fd --type f";
      options = [
        "--preview 'bat {} --color=always --plain'"
        "--preview-window=right:50%"
      ];
    };

    changeDirWidget.command = "fd --type d";
  };
}
