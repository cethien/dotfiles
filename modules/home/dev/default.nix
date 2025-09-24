{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkMerge elem types mkOption;
  cfg = config.deeznuts.dev;
in {
  imports = [
    ./git.nix
    ./chromium.nix
  ];

  options.deeznuts.dev = {
    enable = mkEnableOption "dev tools";
    extras = mkOption {
      type = types.listOf types.str;
      default = [];
    };
  };

  config = let
    containers = elem "containers" cfg.extras;

    chromium = elem "chromium" cfg.extras;

    rider = elem "jetbrains-rider" cfg.extras;
    idea = elem "jetbrains-idea" cfg.extras;
  in
    mkIf cfg.enable {
      home.packages = mkMerge [
        [pkgs.dblab]
        (mkIf idea [pkgs.jetbrains.idea-community])
        (mkIf rider [pkgs.jetbrains.rider])

        (mkIf containers [pkgs.podman-compose pkgs.k3d pkgs.kubectl])
      ];

      services.podman.enable = containers;
      home.shellAliases = mkIf containers {lzd = "lazydocker";};
      programs.lazydocker.enable = containers;
      programs.chromium.enable = chromium;

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
