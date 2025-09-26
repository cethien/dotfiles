{pkgs, ...}: {
  config = {
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

      libqalculate

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
