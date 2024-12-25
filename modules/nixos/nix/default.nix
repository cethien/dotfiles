{ lib, config, pkgs, ... }:

{
  options.nix = {
    enable = lib.mkEnableOption "Enable nix configuration";
    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.nix;
      description = "The nix package to use";
    };
  };

  config = lib.mkIf config.nix.enable {
    nix = {
      package = config.nix.package;

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
