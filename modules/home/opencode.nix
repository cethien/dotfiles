{
  config,
  lib,
  pkgs,
  pkgs-unstable,
  ...
}: let
  cavemanSrc = import ../../packages/caveman-skill.nix {inherit pkgs;};
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
