{ lib, config, inputs, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.deeznuts.programs.zen-browser;
  enabled = cfg.enable;
in
{
  options.deeznuts.programs.zen-browser = {
    enable = mkEnableOption "zen browser";
  };

  config = mkIf enabled {
    home.packages = [
      inputs.zen-browser.packages."x86_64-linux".beta
    ];
  };
}
