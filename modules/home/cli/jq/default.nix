{ lib, config, ... }:

{
  options.cli.jq.enable = lib.mkEnableOption "Enable jq";
  config = lib.mkIf config.cli.jq.enable {
    programs.jq.enable = true;
  };
}
