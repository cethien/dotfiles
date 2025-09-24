{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkBefore mkEnableOption;
  cfg = config.programs.bash;
in {
  options.programs.bash = {
    blesh.enable = mkEnableOption "ble.sh";
  };

  config.programs.bash = {
    initExtra = mkIf cfg.blesh.enable (mkBefore ''
      source ${pkgs.blesh}/share/blesh/ble.sh
    '');
  };
}
