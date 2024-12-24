{ lib, config, ... }:

{
  options.deeznuts.cli.jq.enable = lib.mkEnableOption "Enable jq";
  config = lib.mkIf config.deeznuts.cli.jq.enable {
    programs.jq.enable = true;
  };
}
