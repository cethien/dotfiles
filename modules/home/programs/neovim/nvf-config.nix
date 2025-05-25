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
      indent.enable = true;
    };

    notes = {
      todo-comments.enable = true;
    };

    utility = {
      oil-nvim.enable = true;
      yanky-nvim.enable = true;
    };

    terminal.toggleterm = {
      enable = true;
      mappings.open = "<C-q>";
      lazygit.enable = true;
    };

    telescope.enable = true;
    telescope = {
      mappings.findFiles = "<leader><Space>";
      setupOpts.defaults.file_ignore_patterns = [
        "node_modules"
        "%.git/"
        "%.direnv/"
        "dist/"
        "build/"
        "target/"
        "result/"
      ];
    };

    git.gitsigns.enable = true;

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
    tabline.nvimBufferline = {
      enable = true;
      setupOpts.options = {
        indicator.style = "none";
        numbers = "none";
      };
      mappings = {
        closeCurrent = "<leader>bx";
        cycleNext = "<Tab>";
        cyclePrevious = "<S-Tab>";
        moveNext = "<leader><Tab>";
        movePrevious = "<leader><S-Tab>";
      };
    };
    statusline.lualine.enable = true;
    visuals.nvim-web-devicons.enable = true;

    keymaps = [
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
        key = "<leader>e";
        action = "<cmd>Oil<CR>";
      }
    ];

    theme = {
      enable = true;
      name = "tokyonight";
      style = "night";
      transparent = true;
    };

    options = {
      tabstop = 2;
      shiftwidth = 0;
    };

    globals.mapleader = " ";
    viAlias = true;
    vimAlias = true;
  };
}
