{ lib, config, ... }:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.deeznuts.programs.zoxide;
in
{
  options.deeznuts.programs.zoxide = {
    enable = mkEnableOption "zoxide";
  };

  config = mkIf cfg.enable {
    programs.zoxide = {
      enable = true;
      options = [ "--cmd cd" ];
    };
  };
}
