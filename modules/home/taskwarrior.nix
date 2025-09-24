{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.deeznuts.programs.taskwarrior;
in {
  options.deeznuts.programs.taskwarrior = {
    enable = mkEnableOption "taskwarrior";
  };

  config = mkIf cfg.enable {
    programs.taskwarrior = {
      enable = true;
      package = pkgs.taskwarrior3;
    };

    home.packages = with pkgs; [
      taskwarrior-tui
      timewarrior
    ];
  };
}
