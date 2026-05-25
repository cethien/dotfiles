{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.programs.utils;
in {
  options.programs.utils.enable = lib.mkEnableOption "utils";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      (config.lib.deeznuts.mkArgcBashBin' ./init.sh)
      (writeShellScriptBin "update" (builtins.readFile ./update.sh))
      (writeShellScriptBin "cleanup" (builtins.readFile ./cleanup.sh))
      (writeShellScriptBin "clip" (builtins.readFile ./clip.sh))
      (writeShellScriptBin "uln" (builtins.readFile ./uln.sh))
    ];
  };
}
