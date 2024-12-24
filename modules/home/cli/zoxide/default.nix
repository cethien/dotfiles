{ lib, config, ... }:

{
  options.deeznuts.cli.zoxide.enable = lib.mkEnableOption "Enable zoxide";

  config = lib.mkIf config.deeznuts.cli.zoxide.enable {
    programs.zoxide.enable = true;
    home.shellAliases.cd = "z";
  };
}
