{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.deeznuts.programs.dev;
in {
  imports = [
    ./git.nix
    ./vscode.nix
    ./chromium.nix
    ./jetbrains.nix
  ];

  options.deeznuts.programs.dev.enable = mkEnableOption "dev tools";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [dblab];

    programs = {
      git.enable = true;
      direnv.enable = true;
      direnv = {
        silent = true;
        nix-direnv.enable = true;
        config.global = {
          hide_env_diff = true;
          warn_timeout = 0;
        };
      };

      lazygit.enable = true;
      lazydocker.enable = true;

      gh.enable = true;
      gh-dash.enable = true;
      gh.settings = {
        git_protocol = "ssh";
        prompt = "enable";
      };
    };

    home.shellAliases = {
      lzg = "lazygit";
      lzd = "lazydocker";
    };
  };
}
