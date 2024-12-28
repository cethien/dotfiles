{ lib, config, pkgs, ... }:
let
  inherit (lib) mkIf mkEnableOption mkBefore;
  cfg = config.programs.bash.blesh;
in
{
  options = {
    programs.bash.blesh = {
      enable = mkEnableOption "Enable blesh";
    };
  };

  config = mkIf cfg.enable {
    programs.bash.initExtra = mkBefore ''
      source ${pkgs.blesh}/share/blesh/ble.sh
    '';
  };
}
