{ lib, config, ... }:

{
  options.deeznuts.cli.lazygit.enable = lib.mkEnableOption "Enable lazygit";

  config = lib.mkIf config.deeznuts.cli.lazygit.enable {
    programs.lazygit.enable = true;
    home.shellAliases.lgit = "lazygit";
  };
}
