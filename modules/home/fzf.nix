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

    fileWidgetCommand = "fd --type f";
    fileWidgetOptions = [
      "--preview 'bat {} --color=always --plain'"
      "--preview-window=right:50%"
    ];

    changeDirWidgetCommand = "fd --type d";
  };
}
