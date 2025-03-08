{ lib, config, inputs, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.deeznuts.programs.neovim;
in
{
  imports = [
    inputs.nixvim.homeManagerModules.nixvim
    ./plugins.nix
    ./keymaps.nix
    ./lsp-server.nix
  ];

  options.deeznuts.programs.neovim = {
    enable = mkEnableOption "Enable neovim";
  };

  config = mkIf cfg.enable {
    home.shellAliases.v = "nvim";

    programs.nixvim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;

      globalOpts = {
        number = true;
        signcolumn = "yes";
        mouse = "a";

        # Search
        ignorecase = true;
        smartcase = true;

        # Configure how new splits should be opened
        splitright = true;
        splitbelow = true;

        list = true;
      };

      globals = {
        mapleader = " ";
      };
    };
  };
}
