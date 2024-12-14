{ lib, config, pkgs, ... }:

{
  options.user.dev.go.enable = lib.mkEnableOption "Enable go";

  config = lib.mkIf config.user.dev.go.enable {
    programs.go = {
      enable = true;

      goPath = "go";
      goBin = "go/bin";      
    };

    home.packages = with pkgs; [
      gopls
      delve
    ];
  };
}