{ lib, config, pkgs, ... }:

{
  options.deeznuts.services.podman = {
    enable = lib.mkEnableOption "Podman";
  };

  config = lib.mkIf config.deeznuts.services.podman.enable {
    services.podman.enable = true;
  };
}
