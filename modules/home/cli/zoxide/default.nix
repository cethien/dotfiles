{ lib, config, ... }:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.deeznuts.cli.zoxide;
in
{
  options.deeznuts.cli.zoxide = {
    enable = mkEnableOption "Enable zoxide";
  };

  config = mkIf cfg.enable {
    programs.zoxide.enable = true;
    home.shellAliases.cd = "z";
  };
}
