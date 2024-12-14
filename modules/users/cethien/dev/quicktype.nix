{ lib, config, pkgs, ... }:

{
  options.user.dev.quicktype.enable = lib.mkEnableOption "Enable quicktype";

  config = lib.mkIf config.user.dev.quicktype.enable {
    home.packages = with pkgs; [
      quicktype
    ];
  };
}