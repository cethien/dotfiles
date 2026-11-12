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
    hash = "sha256-I/pMhDvXZp8KOGhWRCNeSIz+3z4ag1m6wdo6kl+JbXs=";
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
