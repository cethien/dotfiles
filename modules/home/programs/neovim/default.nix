{ lib, config, inputs, system, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.deeznuts.programs.neovim;
in
{
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
    programs.nvf.settings = {
      vim.viAlias = true;
      vim.vimAlias = true;
    };

    # programs.nixvim = {
    #   enable = true;
    #   defaultEditor = true;
    #   viAlias = true;
    #   vimAlias = true;

    #   globalOpts = {
    #     number = true;
    #     signcolumn = "yes";
    #     mouse = "a";

    #     # Search
    #     ignorecase = true;
    #     smartcase = true;

    #     # Configure how new splits should be opened
    #     splitright = true;
    #     splitbelow = true;

    #     list = true;
    #   };

    #   globals = {
    #     mapleader = " ";
    #   };
    # };
  };
}
