{pkgs, ...}: {
  programs.nvf.settings.vim.extraPlugins = {
    octo = {
      package = pkgs.vimPlugins.octo-nvim;
      setup = ''
        require("octo").setup({})
      '';
    };
    codesnap = {
      package = pkgs.vimPlugins.codesnap-nvim;
      setup = ''
        require("codesnap").setup({
          save_path = "~/Pictures/CodeSnap",
          has_breadcrumbs = true,
          show_workspace = true,
          has_line_number = true,
          bg_theme = "grape",
          watermark = "",
        })
      '';
    };
  };

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
      blink-cmp.setupOpts.cmdline.keymap.preset = "default";
      blink-cmp.sourcePlugins = {
        spell.enable = true;
        ripgrep.enable = true;
        emoji.enable = true;
      };
      blink-cmp.friendly-snippets.enable = true;
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
      yanky-nvim.enable = true;

      images.image-nvim.enable = true;
      images.image-nvim.setupOpts.backend = "kitty";

      oil-nvim.enable = true;
      yazi-nvim.enable = true;
      yazi-nvim.setupOpts.open_for_directories = true;

      motion = {
        flash-nvim.enable = true;
      };
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

    git = {
      gitsigns.enable = true;
      gitlinker-nvim.enable = true;
      gitlinker-nvim.setupOpts.mappings = "<leader>gy";
    };

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
        closeCurrent = "<leader>x";
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
        mode = "n";
        key = "<leader>e";
        action = "<cmd>Oil<CR>";
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
        key = "<leader>w";
        action = "<cmd>w<CR>";
      }
    ];

    presence.neocord.enable = true;

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
