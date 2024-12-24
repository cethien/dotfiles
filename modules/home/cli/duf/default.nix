{ lib, config, pkgs, ... }:

{
  options.deeznuts.cli.duf.enable = lib.mkEnableOption "Enable duf";

  config = lib.mkIf config.deeznuts.cli.duf.enable {
    home.packages = with pkgs; [
      duf
    ];

    home.shellAliases = {
      df = "duf";
    };
  };
}

