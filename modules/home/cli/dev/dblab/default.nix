{ lib, config, pkgs, ... }:

{
  options.deeznuts.cli.dev.dblab.enable = lib.mkEnableOption "Enable dblab";

  config = lib.mkIf config.deeznuts.cli.dev.dblab.enable {
    home.packages = with pkgs; [ dblab ];
  };
}
