{ lib, config, ... }:

{
  options.deeznuts.cli.dev.lazygit.enable = lib.mkEnableOption "Enable lazygit";

  config = lib.mkIf config.deeznuts.cli.dev.lazygit.enable {
    programs.lazygit.enable = true;
    home.shellAliases.lgit = "lazygit";
  };
}
