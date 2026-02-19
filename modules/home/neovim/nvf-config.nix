{pkgs, ...}: {
  vim = {
    extraPackages = with pkgs; [fzf lazygit sops gh];

    extraPlugins = with pkgs.vimPlugins; {
      sops = {
        package = nvim-sops;
        setup =
          #lua
          ''
            require("nvim_sops").setup {
              defaults = { ageKeyFile = '$HOME/.sops/age/keys.txt' }
            }
          '';
      };
      csv = {
        package = csvview-nvim;
        setup =
          #lua
          ''
            require("csvview").setup {}
          '';
      };
      octo = {
        package = octo-nvim;
        setup =
          #lua
          ''
            require("octo").setup {
              picker = "fzf-lua",
            }
          '';
      };
      codesnap = {
        package = codesnap-nvim;
        setup =
          #lua
          ''
            require("codesnap").setup {
              save_path = "~/Pictures/CodeSnap",
              has_breadcrumbs = true,
              show_workspace = true,
              has_line_number = true,
              bg_theme = "grape",
              watermark = "",
            }
          '';
      };
    };

    autocmds = [
      {
        event = ["BufWritePost"];
        pattern = ["vim.env.MYVIMRC"];
        command = "silent source %";
      }
    ];

    languages = {
      java.enable = true;
      python.enable = true;
      rust.enable = true;
      clang.enable = true;
      go.enable = true;
      csharp.enable = true;

      astro.enable = true;
      svelte.enable = true;
      tailwind.enable = true;
      php.enable = true;
      ts.enable = true;
      ts.extensions.ts-error-translator.enable = true;
      css.enable = true;
      html.enable = true;

      sql.enable = true;

      nix.enable = true;
      lua.enable = true;
      bash.enable = true;
      yaml.enable = true;
      typst.enable = true;
      markdown.enable = true;
      markdown.extensions.markview-nvim.enable = true;

      enableFormat = true;
      enableTreesitter = true;
      enableDAP = true;
    };

    lsp.enable = true;
    lsp = {
      trouble.enable = true;
      null-ls.enable = true;
      otter-nvim.enable = true;

      inlayHints.enable = true;
      formatOnSave = true;
    };

    autocomplete = {
      enableSharedCmpSources = true;

      # TODO: path autocomplete does not work. did work in nixvim, and in path is in defaults list
      blink-cmp = {
        enable = true;
        setupOpts.cmdline.keymap.preset = "default";
        sourcePlugins = {
          spell.enable = true;
          ripgrep.enable = true;
          emoji.enable = true;
        };
        friendly-snippets.enable = true;
      };
    };

    mini = {
      comment.enable = true;
      move.enable = true;
      operators.enable = true;
      pairs.enable = true;
      surround.enable = true;
      splitjoin.enable = true;
      misc.enable = true;
    };

    treesitter = {
      highlight.enable = true;
      autotagHtml = true;
      fold = true;
      indent.enable = true;
      # context.enable = true;
    };

    notes = {
      todo-comments.enable = true;
    };

    dashboard = {
      alpha.enable = true;
      alpha = {
        theme = "dashboard";
      };
    };

    utility = {
      # yanky-nvim.enable = true;

      images.image-nvim.enable = true;
      images.image-nvim.setupOpts.backend = "kitty";

      icon-picker.enable = true;
      ccc.enable = true;

      # TODO: https://github.com/NotAShelf/nvf/issues/1312#issuecomment-3741078541
      #
      # nvim-biscuits.enable = true;
      # nvim-biscuits.setupOpts = {
      #   cursor_line_only = true;
      #   languageConfig = {
      #     markdown.disabled = true;
      #   };
      # };

      diffview-nvim.enable = true;
      oil-nvim.enable = true;
      direnv.enable = true;
      yazi-nvim.enable = true;
      yazi-nvim.setupOpts.open_for_directories = true;

      motion = {
        flash-nvim.enable = true;
      };
    };

    fzf-lua = {
      enable = true;
      setupOpts = {
        winopts = {
          height = 0.8;
          width = 0.9;
        };
        file_ignore_patterns = [
          "node_modules"
          "%.git/"
          "%.direnv/"
          "dist/"
          "build/"
          "target/"
          "result/"
        ];
      };
    };

    git = {
      gitsigns.enable = true;
      gitlinker-nvim.enable = true;
      gitlinker-nvim.setupOpts.mappings = "<leader>gy";
    };

    session.nvim-session-manager = {
      enable = true;
      setupOpts = {
        autoload_mode = "CurrentDir";
        autosave_ignore_filetypes = [
          "gitcommit"
          "toggleterm"
        ];
        autosave_ignore_buftypes = [
          "terminal"
        ];
      };
    };

    terminal.toggleterm = {
      enable = true;
      lazygit.enable = true;
      lazygit.direction = "float";
    };

    spellcheck.enable = true;
    spellcheck.languages = [
      "en"
      # "de"
      # "ru"
    ];
    spellcheck.programmingWordlist.enable = true;
    diagnostics.enable = true;
    diagnostics.config = {
      signs.text = {
        "vim.diagnostic.severity.ERROR" = "󰅚 ";
        "vim.diagnostic.severity.WARN" = "󰀪 ";
      };
      virtual_text = true;
    };
    ui = {
      fastaction.enable = true;
      colorizer.enable = true;
      modes-nvim.enable = true;
      noice.enable = true;
      smartcolumn.enable = true;

      borders.enable = true;
      breadcrumbs.navbuddy.enable = true;
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
    visuals = {
      nvim-web-devicons.enable = true;
      nvim-scrollbar.enable = true;
    };

    clipboard.enable = true;
    clipboard.providers.wl-copy.enable = true;

    keymaps = [
      {
        mode = "n";
        key = "<leader><Space>";
        action = "<cmd>FzfLua files<CR>";
      }
      {
        mode = "n";
        key = "<leader>fb";
        action = "<cmd>FzfLua buffers<CR>";
      }
      {
        mode = "n";
        key = "<leader>fg";
        action = "<cmd>FzfLua live_grep<CR>";
      }
      {
        mode = "n";
        key = "<leader>fw";
        action = "<cmd>FzfLua git_worktrees<CR>";
      }

      {
        mode = "n";
        key = "<leader>oi";
        action = "<cmd>Octo issue list<CR>";
      }
      {
        mode = "n";
        key = "<leader>op";
        action = "<cmd>Octo pr list<CR>";
      }
      {
        mode = "n";
        key = "<leader>od";
        action = "<cmd>Octo discussion list<CR>";
      }

      {
        mode = "n";
        key = "<leader>df";
        action = "<cmd>SopsDecrypt<CR>";
      }
      {
        mode = "n";
        key = "<leader>ef";
        action = "<cmd>SopsEncrypt<CR>";
      }

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
        mode = "v";
        key = "<leader>y";
        action = ''"+y'';
      }
      {
        mode = "v";
        key = "<leader>p";
        action = ''"+p'';
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

    theme = {
      enable = true;
      name = "tokyonight";
      style = "night";
      transparent = true;
    };

    options = {
      tabstop = 2;
      shiftwidth = 0;
      conceallevel = 2;
      linebreak = true;
      breakindent = true;
      # colorcolumn = "80";
    };

    globals.mapleader = " ";
    viAlias = true;
    vimAlias = true;
  };
}
