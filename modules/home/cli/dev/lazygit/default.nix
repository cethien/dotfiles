{ lib, config, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.deeznuts.cli.dev.lazygit;
in
{
  options.deeznuts.cli.dev.lazygit = {
    enable = mkEnableOption "Enable lazygit";
  };

  config = mkIf cfg.enable {
    programs.lazygit.enable = true;
    home.shellAliases.lgit = "lazygit";
  };
}
