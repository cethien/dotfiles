{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf mkOption types;

  ffpmeg-convert = pkgs.cethien.mkArgcBashBin {
    src = ./ffmpeg-convert.sh;
    extraRuntimeDeps = [pkgs.ffmpeg pkgs.gawk];
  };

  init = pkgs.cethien.mkArgcBashBin' ./init.sh;
in {
  options.programs.utils = {
    enable = mkOption {
      type = types.bool;
      default = true;
    };
  };

  config = mkIf config.programs.utils.enable {
    home.packages = with pkgs; [
      gnutar
      gzip
      bzip2
      bzip3
      xz
      zip
      unzip
      rar
      p7zip

      poppler-utils # pdf stuff
      lynx # term browser
      aria2 # download manager
      parted
      openssl

      ffmpeg
      ffpmeg-convert

      init
      (writeShellScriptBin "switch" (builtins.readFile ./switch.sh))
      (writeShellScriptBin "update" (builtins.readFile ./update.sh))
      (writeShellScriptBin "cleanup" (builtins.readFile ./cleanup.sh))
      (writeShellScriptBin "clip" (builtins.readFile ./clip.sh))
      (writeShellScriptBin "uln" (builtins.readFile ./uln.sh))

      taskwarrior-tui
      timewarrior
    ];

    programs = {
      nix-index.enable = true;
      pay-respects.enable = true;

      jq.enable = true;
      taskwarrior = {
        enable = true;
        package = pkgs.taskwarrior3;
      };
    };
  };
}
