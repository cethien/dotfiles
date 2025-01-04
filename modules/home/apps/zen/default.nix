{ config, lib, pkgs, inputs, ... }:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.deeznuts.apps.zen;
in
{
  options.deeznuts.apps.zen = {
    enable = mkEnableOption "zen browser";
  };

  config = mkIf cfg.enable {
    home.packages = [ inputs.zen-browser.packages.${pkgs.system}.default ];
  };
}
