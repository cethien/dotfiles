{ lib, config, ... }:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.deeznuts.nixpkgs;
in
{
  options.deeznuts.nixpkgs = {
    allowUnfree = mkEnableOption "Allow unfree packages";
  };

  config = mkIf cfg.allowUnfree {
    nixpkgs.config = {
      allowUnfree = true;
      allowUnfreePredicate = (_: true);
    };
  };
}
