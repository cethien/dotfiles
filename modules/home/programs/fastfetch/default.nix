{ lib, config, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.deeznuts.programs.fastfetch;
in
{
  options.deeznuts.programs.fastfetch = {
    enable = mkEnableOption "Enable fastfetch";
  };
  config = mkIf cfg.enable {
    programs.fastfetch.enable = true;
  };
}
