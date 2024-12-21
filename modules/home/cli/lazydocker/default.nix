{ lib, config, pkgs, ... }:

{
  options.cli.lazydocker.enable = lib.mkEnableOption "Enable lazydocker";

  config = lib.mkIf config.cli.lazydocker.enable {
    home.packages = with pkgs; [ lazydocker ];
    home.shellAliases.ldocker = "lazydocker";
  };
}
