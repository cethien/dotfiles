{ lib, config, pkgs, ... }:

{
  options.user.dev.act.enable = lib.mkEnableOption "Enable act";

  config = lib.mkIf config.user.dev.act.enable {
    home.packages = with pkgs; [
      act
    ];
  };
}