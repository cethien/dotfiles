{ lib, pkgs, ... }:

{
  options.deeznuts.services.podman = {
    enable = lib.mkEnableOption "Podman";
  };
}
