{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkMerge;
  cfg = config.deeznuts.programs.dev;
in {
  imports = [
    ./git.nix
    ./containers.nix
    ./chromium.nix
  ];

  options.deeznuts.programs.dev = {
    enable = mkEnableOption "dev tools";
    ide = {
      vscode.enable = mkEnableOption "vscode";
      jetbrains = {
        idea.enable = mkEnableOption "Jetbrains IntelliJ Community IDE";
        rider.enable = mkEnableOption "Jetbrains Rider IDE";
      };
    };
    chromium.enable = mkEnableOption "chromium browser";
    containers.enable = mkEnableOption "enable containers";
  };

  config = mkIf cfg.enable {
    home.packages = mkMerge [
      (mkIf cfg.ide.jetbrains.idea.enable [pkgs.jetbrains.idea-community])
      (mkIf cfg.ide.jetbrains.rider.enable [pkgs.jetbrains.rider])
      [pkgs.dblab]
    ];

    stylix.targets.vscode.enable = false;
    programs = {
      chromium.enable = cfg.chromium.enable;
      vscode.enable = cfg.ide.vscode.enable;
      direnv.enable = true;
      direnv = {
        silent = true;
        nix-direnv.enable = true;
        config.global = {
          hide_env_diff = true;
          warn_timeout = 0;
        };
      };
      gh.enable = true;
      gh-dash.enable = true;
      gh.settings = {
        git_protocol = "ssh";
      };
      git.enable = true;
    };
  };
}
