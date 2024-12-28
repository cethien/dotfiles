{ lib, config, ... }:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.deeznuts.services.podman;
in
{
  options.deeznuts.services.podman = {
    enable = mkEnableOption "Enable podman";
  };

  config = mkIf cfg.enable {
    services.podman.enable = true;
  };
}
