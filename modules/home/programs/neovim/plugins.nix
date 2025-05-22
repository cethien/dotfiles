{
  programs.nixvim = {
    plugins = {
      presence-nvim.enable = true;

      auto-session.enable = true;

      transparent.enable = true;
      web-devicons.enable = true;
      lualine.enable = true;
      bufferline.enable = true;
      # dropbar.enable = true;
      image.enable = true;
      blink-cmp.enable = true;
      commentary.enable = true;
      cursorline.enable = true;
      telescope.enable = true;
      telescope.settings = {
        defaults = {
          file_ignore_patterns = [
            "^.git/"
            "^node_modules"
            "^.direnv"
          ];
        };
      };

      toggleterm.enable = true;
      oil.enable = true;
      gx.enable = true;
      yanky.enable = true;
      markview.enable = true;

      direnv.enable = true;
      nix.enable = true;
      nix-develop.enable = true;

      lazygit.enable = true;
      gitsigns.enable = true;
      octo.enable = true;

      dap.enable = true;

      vim-css-color.enable = true;
      todo-comments.enable = true;

      schemastore.enable = true;

      autoclose.enable = true;

      treesitter.enable = true;
      treesitter.settings = {
        highlight.enable = true;
      };
      rest.enable = true;
      luasnip.enable = true;

      vim-dadbod.enable = true;
      vim-dadbod-completion.enable = true;
      vim-dadbod-ui.enable = true;
    };
  };
}
