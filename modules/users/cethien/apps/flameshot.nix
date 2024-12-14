{ lib, config, pkgs, ... }:

{
  options.user.apps.flameshot.enable = lib.mkEnableOption "Enable Flameshot";

  config = lib.mkIf config.user.apps.flameshot.enable {
    home.packages =  with pkgs; [ 
      (flameshot.override { enableWlrSupport = true; })
    ];
  };
}