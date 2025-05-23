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
      cursorline.enable = true;

      commentary.enable = true;

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

      blink-cmp.enable = true;
      blink-cmp.settings.sources.default = [
        "lsp"
        "path"
        "buffer"
        "emoji"
        "dictionary"
      ];

      blink-emoji.enable = true;
      blink-cmp.settings.sources.providers.emoji = {
        module = "blink-emoji";
        name = "Emoji";
        score_offset = 15;
        opts = {
          insert = true;
        };
      };

      blink-cmp-dictionary.enable = true;
      blink-cmp.settings.sources.providers.dictionary = {
        module = "blink-cmp-dictionary";
        name = "Dict";
        score_offset = 100;
        min_keyword_length = 3;
      };

      blink-cmp-git.enable = true;



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
