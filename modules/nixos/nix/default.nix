{ lib, config, pkgs, ... }:
let
  inherit (lib) mkIf mkEnableOption mkOption;
  inherit (lib.types) package;
  cfg = config.deeznuts.nix;
in
{
  options.deeznuts.nix = {
    enable = mkEnableOption "Enable nix configuration";
    package = mkOption {
      type = package;
      default = pkgs.nix;
      description = "The nix package to use";
    };
  };

  config = mkIf cfg.enable {
    nix = {
      package = cfg.package;

      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 7d";
      };

      settings = {
        extra-experimental-features = "nix-command flakes";
        warn-dirty = false;
        trusted-users = [ "@wheel" ];
        allowed-users = [ "@wheel" ];
      };
    };
  };
}
