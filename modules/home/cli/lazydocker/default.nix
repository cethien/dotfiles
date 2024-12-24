{ lib, config, pkgs, ... }:

{
  options.deeznuts.cli.lazydocker.enable = lib.mkEnableOption "Enable lazydocker";

  config = lib.mkIf config.deeznuts.cli.lazydocker.enable {
    home.packages = with pkgs; [ lazydocker ];
    home.shellAliases.ldocker = "lazydocker";
  };
}
