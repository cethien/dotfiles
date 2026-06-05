{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (config.lib.deeznuts.argc) mkBashBin';
  cfg = config.programs.utils;
in {
  options.programs.utils.enable = lib.mkEnableOption "utils";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      (mkBashBin' ./init.sh)
      (writeShellScriptBin "update" (builtins.readFile ./update.sh))
      (writeShellScriptBin "cleanup" (builtins.readFile ./cleanup.sh))
      (writeShellScriptBin "clip" (builtins.readFile ./clip.sh))
      (writeShellScriptBin "uln" (builtins.readFile ./uln.sh))
    ];
  };
}
