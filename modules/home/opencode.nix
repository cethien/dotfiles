{
  config,
  lib,
  pkgs,
  pkgs-unstable,
  ...
}: let
  cavemanSrc = pkgs.fetchFromGitHub {
    owner = "JuliusBrussee";
    repo = "caveman";
    rev = "main";
    hash = "sha256-1X2DjYa4xqO1ZqwxdFjCmaypp0+HYncEpXaut4i9LkE=";
  };
in {
  config = lib.mkIf config.programs.opencode.enable {
    programs.opencode = {
      package = pkgs-unstable.opencode;
      skills = {
        caveman = "${cavemanSrc}/skills/caveman";
      };
    };

    programs.tmux.resurrectPluginProcesses = ["opencode"];
  };
}
