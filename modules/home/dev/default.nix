{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkMerge elem types mkOption;
  cfg = config.programs.devSuite;
in {
  imports = [
    ./git.nix
  ];

  options.programs.devSuite = {
    extras = mkOption {
      type = types.listOf types.str;
      default = [];
    };
  };

  config = let
    containers = elem "containers" cfg.extras;

    rider = elem "jetbrains-rider" cfg.extras;
    idea = elem "jetbrains-idea" cfg.extras;
  in {
    home.packages = mkMerge [
      [pkgs.dblab]
      (mkIf idea [pkgs.jetbrains.idea-community])
      (mkIf rider [pkgs.jetbrains.rider])
      (mkIf containers [pkgs.podman-compose pkgs.k3d pkgs.kubectl])
    ];

    services.podman.enable = containers;
    home.shellAliases = mkIf containers {lzd = "lazydocker";};
    programs.lazydocker.enable = containers;

    programs.tmux.resurrectPluginProcesses = ["dblab" "lazydocker" "gh-dash"];

    programs = {
      gh-dash.enable = true;
      gh.enable = true;
      gh.settings = {
        git_protocol = "ssh";
      };

      direnv = {
        enable = true;
        silent = true;
        nix-direnv.enable = true;
        config.global = {
          hide_env_diff = true;
          warn_timeout = 0;
        };
      };

      git.enable = true;
    };
  };
}
