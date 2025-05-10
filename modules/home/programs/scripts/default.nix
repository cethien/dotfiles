{ lib, config, pkgs, ... }:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.deeznuts.programs.scripts;
in
{
  options.deeznuts.programs.scripts = {
    enable = mkEnableOption "Enable scripts";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      (writeShellScriptBin "update" (builtins.readFile ./update.sh))
      (writeShellScriptBin "rebuild" (builtins.readFile ./rebuild.sh))
      (writeShellScriptBin "cleanup" (builtins.readFile ./cleanup.sh))
      (writeShellScriptBin "init" (builtins.readFile ./init.sh))
    ];

    home.shellAliases.rebuild-nixos = "rebuild -n";
  };
}
