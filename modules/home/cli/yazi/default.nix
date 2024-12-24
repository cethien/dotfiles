{ lib, config, ... }:

{
  options.deeznuts.cli.yazi.enable = lib.mkEnableOption "Enable yazi";

  config = lib.mkIf config.deeznuts.cli.yazi.enable {
    programs.yazi.enable = true;
  };
}
