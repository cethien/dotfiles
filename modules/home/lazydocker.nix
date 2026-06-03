{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  cfg = config.programs.lazydocker;
in {
  config = mkIf cfg.enable {
    home.shellAliases.lzd = "lazydocker";
    programs.tmux.resurrectPluginProcesses = ["lazydocker"];
  };
}
