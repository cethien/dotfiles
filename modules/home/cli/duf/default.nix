{ lib, config, pkgs, ... }:

{
  options.cli.duf.enable = lib.mkEnableOption "Enable duf";

  config = lib.mkIf config.cli.duf.enable {
    home.packages = with pkgs; [
      duf
    ];

    home.shellAliases = {
      df = "duf";
    };
  };
}

