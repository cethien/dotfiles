{ lib, config, ... }:

{
  options.cli.zoxide.enable = lib.mkEnableOption "Enable zoxide";

  config = lib.mkIf config.cli.zoxide.enable {
    programs.zoxide.enable = true;
    home.shellAliases.cd = "z";
  };
}
