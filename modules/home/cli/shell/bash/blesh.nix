{ lib, config, pkgs, ... }:

let
  cfg = config.programs.bash.blesh;
in
{
  options = {
    programs.bash.blesh.enable = lib.mkEnableOption "blesh, a full-featured line editor written in pure Bash";
  };

  config = lib.mkIf cfg.enable {
    programs.bash.initExtra = lib.mkBefore ''
      source ${pkgs.blesh}/share/blesh/ble.sh
    '';
  };
}
