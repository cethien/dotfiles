{
  lib,
  config,
  pkgs,
  pkgs-unstable,
  ...
}: let
  inherit (lib) mkIf;
  cfg = config.programs.lazydocker;
in {
  config = mkIf cfg.enable {
    # https://github.com/jesseduffield/lazydocker/blob/master/docs/Config.md
    programs.lazydocker = {
      package = pkgs-unstable.lazydocker;
      settings = {
        commandTemplates = {
          dockerCompose = "docker compose";
        };
      };
    };

    programs.tmux.resurrectPluginProcesses = ["lazydocker"];
    home.shellAliases.lzd = "lazydocker";
  };
}
