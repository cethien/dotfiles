{
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    ./git.nix
    ./container-tools.nix
  ];

  config = {
    programs.tmux.resurrectPluginProcesses = ["gh-dash"];

    programs = {
      lazysql.enable = true;

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
