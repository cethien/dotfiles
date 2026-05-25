{
  lib,
  config,
  pkgs,
  ...
}: let
in {
  config.programs.fzf = {
    defaultCommand = "fd --type f";
    defaultOptions = ["--layout=reverse"];

    fileWidgetCommand = "fd --type f";
    fileWidgetOptions = [
      "--preview 'bat {} --color=always --plain'"
    ];

    changeDirWidgetCommand = "fd --type d";
    changeDirWidgetOptions = [
      "--preview 'eza {} -1a --icons=always --color=always'"
    ];
  };
}
