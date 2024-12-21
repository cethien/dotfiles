{ lib, config, ... }:

{
  options.cli.lazygit.enable = lib.mkEnableOption "Enable lazygit";

  config = lib.mkIf config.cli.lazygit.enable {
    programs.lazygit.enable = true;
    home.shellAliases.lgit = "lazygit";
  };
}
