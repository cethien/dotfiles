{ lib, config, pkgs, ... }:

{
  options.deeznuts.cli.dev.lazydocker.enable = lib.mkEnableOption "Enable lazydocker";

  config = lib.mkIf config.deeznuts.cli.dev.lazydocker.enable {
    home.packages = with pkgs; [ lazydocker ];
    home.shellAliases.ldocker = "lazydocker";
  };
}
