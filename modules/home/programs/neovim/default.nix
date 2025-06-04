{
  lib,
  config,
  nvf,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.deeznuts.programs.neovim;
in {
  imports = [
    nvf.homeManagerModules.default
    ./nvf-config.nix
  ];

  options.deeznuts.programs.neovim = {
    enable = mkEnableOption "neovim";
  };

  config = mkIf cfg.enable {
    home.sessionVariables.EDITOR = "nvim";
    home.shellAliases.v = "nvim";
    programs.nvf.enable = true;
  };
}
