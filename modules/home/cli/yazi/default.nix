{ lib, config, ... }:

{
  options.cli.yazi.enable = lib.mkEnableOption "Enable yazi";

  config = lib.mkIf config.cli.yazi.enable {
    programs.yazi.enable = true;
  };
}
