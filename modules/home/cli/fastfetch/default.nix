{ lib, config, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.deeznuts.cli.fastfetch;
in
{
  options.deeznuts.cli.fastfetch = {
    enable = mkEnableOption "Enable fastfetch";
  };
  config = mkIf cfg.enable {
    programs.fastfetch.enable = true;
  };
}
