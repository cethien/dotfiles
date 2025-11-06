{
  pkgs,
  lib,
}: {
  config = {
    bash.initExtra = lib.mkBefore ''
      source ${pkgs.blesh}/share/blesh/ble.sh
    '';
  };
}
