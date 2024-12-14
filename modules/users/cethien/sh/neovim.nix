{ pkgs, ... }:

{
  programs.neovim = {
    enable = true;

    defaultEditor = true;

    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    plugins = with pkgs.vimPlugins; [
      comment-nvim

      vim-nix
    ];

    extraConfig = ''
      set number
    '';
  };
}
