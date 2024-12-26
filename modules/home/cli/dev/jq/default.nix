{ lib, config, ... }:

{
  options.deeznuts.cli.dev.jq.enable = lib.mkEnableOption "Enable jq";
  config = lib.mkIf config.deeznuts.cli.dev.jq.enable {
    programs.jq.enable = true;
  };
}
