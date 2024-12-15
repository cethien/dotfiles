{ lib, config, pkgs, ... }:

{
  options.user.dev.make.enable = lib.mkEnableOption "Enable gnumake";

  config = lib.mkIf config.user.dev.make.enable {
    home.packages = with pkgs; [
      gnumake
    ];
  };
}
