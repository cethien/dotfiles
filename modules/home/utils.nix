{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf mkOption types;
in {
  options.programs.utils = {
    enable = mkOption {
      type = types.bool;
      default = true;
    };
  };

  config = mkIf config.programs.utils.enable {
    home.packages = with pkgs; [
      zip
      unzip
      rar
      # unrar
      p7zip
      poppler_utils # pdf stuff
      lynx # term browser
      aria2 # download manager
      parted

      ffmpeg
      (writeShellScriptBin "ffmpeg-convert" (builtins.readFile ./ffmpeg-convert.sh))

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
