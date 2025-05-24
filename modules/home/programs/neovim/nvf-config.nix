{
  programs.nvf.settings.vim = {
    languages = {
      clang.enable = true;
      go.enable = true;
      csharp.enable = true;

      astro.enable = true;
      svelte.enable = true;
      tailwind.enable = true;
      php.enable = true;
      ts.enable = true;
      css.enable = true;
      html.enable = true;

      sql.enable = true;

      nix.enable = true;
      lua.enable = true;
      bash.enable = true;
      yaml.enable = true;
      markdown.enable = true;
      markdown.extensions.markview-nvim.enable = true;

      enableFormat = true;
      enableTreesitter = true;
      enableDAP = true;
    };

    lsp.enable = true;
    lsp = {
      trouble.enable = true;
      otter-nvim.enable = true;

      inlayHints.enable = true;
      formatOnSave = true;
    };

    autocomplete = {
      enableSharedCmpSources = true;

      blink-cmp.enable = true;
      blink-cmp.sourcePlugins = {
        spell.enable = true;
        emoji.enable = true;
      };
    };

    mini = {
      comment.enable = true;
      move.enable = true;
      operators.enable = true;
      pairs.enable = true;
      surround.enable = true;
      splitjoin.enable = true;
    };

    treesitter = {
      highlight.enable = true;
      autotagHtml = true;
      fold = true;
    };

    utility = {
      oil-nvim.enable = true;
      yanky-nvim.enable = true;
    };

    terminal.toggleterm = {
      enable = true;
      lazygit.enable = true;
    };

    telescope.enable = true;
    telescope.setupOpts.defaults.file_ignore_patterns = [
      "node_modules"
      "%.git/"
      "%.direnv/"
      "dist/"
      "build/"
      "target/"
      "result/"
    ];

    git.enable = true;

    session.nvim-session-manager = {
      enable = true;
      setupOpts = {
        autosave_ignore_filetypes = [
          "gitcommit"
          "toggleterm"
        ];
        autosave_ignore_buftypes = [
          "terminal"
        ];
      };
    };

    ui = {
      fastaction.enable = true;
      colorizer.enable = true;
      modes-nvim.enable = true;
      noice.enable = true;
      smartcolumn.enable = true;

      borders.enable = true;
    };
    statusline.lualine.enable = true;
    tabline.nvimBufferline.enable = true;
    visuals.nvim-web-devicons.enable = true;

    keymaps = [
      {
        mode = "n";
        key = "<leader>qq";
        action = "<cmd>quit<CR>";
      }
      {
        mode = "n";
        key = "<leader>qa";
        action = "<cmd>quitall<CR>";
      }

      {
        mode = "t";
        key = "<C-n>";
        action = ''<C-\><C-n>'';
        noremap = true;
      }

      {
        mode = "n";
        key = "<leader>/";
        action = "<cmd>noh<CR>";
      }

      {
        mode = "n";
        key = "<leader>vs";
        action = "<cmd>vs<CR>";
      }
      {
        mode = "n";
        key = "<leader><Left>";
        action = "<cmd>wincmd h<CR>";
      }
      {
        mode = "n";
        key = "<leader><Right>";
        action = "<cmd>wincmd l<CR>";
      }
      {
        mode = "n";
        key = "<leader><Up>";
        action = "<cmd>wincmd k<CR>";
      }
      {
        mode = "n";
        key = "<leader><Down>";
        action = "<cmd>wincmd l<CR>";
      }

      {
        mode = "n";
        key = "<leader>sv";
        action = "<cmd>source $MYVIMRC<CR>";
      }

      {
        mode = "n";
        key = "<leader>w";
        action = "<cmd>write<CR>";
      }

      {
        mode = "n";
        key = "<leader>e";
        action = "<cmd>Oil<CR>";
      }

      {
        mode = "n";
        key = "<leader>t";
        action = "<cmd>ToggleTerm<CR>";
      }

      {
        mode = "n";
        key = "<leader><Space>";
        action = "<cmd>Telescope find_files<cr>";
      }
      {
        mode = "n";
        key = "<leader>fb";
        action = "<cmd>Telescope buffers<cr>";
      }
      {
        mode = "n";
        key = "<leader>fc";
        action = "<cmd>Telescope commands<CR>";
      }
      {
        mode = "n";
        key = "<leader>fg";
        action = "<cmd>Telescope live_grep<CR>";
      }

      {
        mode = "n";
        key = "<Tab>";
        action = "<cmd>BufferLineCycleNext<cr>";
      }
      {
        mode = "n";
        key = "<S-Tab>";
        action = "<cmd>BufferLineCyclePrev<cr>";
      }
    ];

    theme = {
      enable = true;
      name = "tokyonight";
      style = "night";
      transparent = true;
    };

    globals.mapleader = " ";
    viAlias = true;
    vimAlias = true;
  };
}
