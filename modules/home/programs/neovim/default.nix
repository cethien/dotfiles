{
  lib,
  config,
  pkgs,
  nvf,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.deeznuts.programs.neovim;
in {
  imports = [
    nvf.homeManagerModules.default
  ];

  options.deeznuts.programs.neovim = {
    enable = mkEnableOption "neovim";
  };

  config = mkIf cfg.enable {
    home.sessionVariables.EDITOR = "nvim";
    home.shellAliases.v = "nvim";
    programs.nvf.enable = true;
    programs.nvf.settings = import ./nvf-config.nix {
      inherit pkgs;
      ageFile = config.sops.age.keyFile;
    };
  };
}
