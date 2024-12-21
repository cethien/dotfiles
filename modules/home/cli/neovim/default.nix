{ lib, config, pkgs, ... }:

{
  options.cli.neovim.enable = lib.mkEnableOption "Enable neovim";

  config = lib.mkIf config.cli.neovim.enable {
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
  };
}
