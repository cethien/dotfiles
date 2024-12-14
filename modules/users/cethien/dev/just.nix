{ lib, config, pkgs, ... }:

{
  options.user.dev.just.enable = lib.mkEnableOption "Enable just";

  config = lib.mkIf config.user.dev.just.enable {
    home.packages = with pkgs; [
      just
    ];
  };
}