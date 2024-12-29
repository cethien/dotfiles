{ lib, config, ... }:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.deeznuts.nix;
in
{
  options.deeznuts.nix = {
    enable = mkEnableOption "Enable nix configuration";
  };

  config = mkIf cfg.enable {
    nix = {
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
