{
  lib,
  config,
  inputs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.deeznuts.programs.neovim;
in {
  imports = [
    inputs.nvf.homeManagerModules.default
    ./nvf-config.nix
  ];

  options.deeznuts.programs.neovim = {
    enable = mkEnableOption "neovim";
  };

  config = mkIf cfg.enable {
    home.shellAliases.v = "nvim";
    programs.nvf.enable = true;
  };
}
