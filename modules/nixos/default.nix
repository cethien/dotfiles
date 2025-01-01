{ lib, config, ... }:
let
  inherit (lib) mkOption;
  inherit (lib.types) str;
  cfg = config.deeznuts;
in
{
  imports = [
    ../shared/nixpkgs
    ./nix

    ./boot

    ./networking
    ./localization
    ./keymapping
    ./users

    ./apps
    ./desktop
    ./hardware
    ./services
    ./virtualisation
  ];

  options.deeznuts = {
    hostname = mkOption {
      type = str;
      default = "nixos";
      description = "The hostname to use for home-manager";
    };
  };

  config = {
    networking.hostName = cfg.hostname;
  };
}
