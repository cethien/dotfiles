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
    rev = "a192894723a8f47e7f504c7b5041967ff1f18e55";
    hash = "sha256-qG7njZgc+JCg+AAVNcFmOYjWMIAy73q4BociYG+WsEw=";
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
