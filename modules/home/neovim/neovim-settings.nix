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
    };

    autocmds = [
      {
        event = ["BufWritePost"];
        pattern = ["vim.env.MYVIMRC"];
        command = "silent source %";
      }
    ];

    languages = {
      go.enable = true;
      go.extensions.gopher-nvim.enable = true;
      csharp.enable = true;
      clang.enable = true;
      java.enable = true;
      java.extensions = {
        maven-nvim.enable = true;
        gradle-nvim.enable = true;
      };
      rust.enable = true;
      rust.extensions.crates-nvim.enable = true;
      python.enable = true;

      php.enable = true;
      html.enable = true;
      css.enable = true;
      typescript.enable = true;
      typescript.extensions.ts-error-translator.enable = true;
      tsx.enable = true;
      svelte.enable = true;
      vue.enable = true;
      astro.enable = true;

      sql.enable = true;
      jq.enable = true; # sidenote: WHY DOES THIS EXIST?!?!?!

      xml.enable = true;
      json.enable = true;
      yaml.enable = true;
      toml.enable = true;
      # ---
      env.enable = true;
      docker.enable = true;
      helm.enable = true;
      hcl.enable = true;
      terraform.enable = true;

      markdown.enable = true;
      markdown.extensions.markview-nvim.enable = true;
      typst.enable = true;
      typst.extensions = {
        typst-concealer.enable = true;
        typst-preview-nvim.enable = true;
      };
      tex.enable = true;

      nix.enable = true;
      lua.enable = true;
      bash.enable = true;
      just.enable = true;
      make.enable = true;

      enableFormat = true;
      enableTreesitter = true;
      enableDAP = true;
    };

    lsp.enable = true;
    lsp = {
      presets = {
        tailwindcss-language-server.enable = true;
      };

      trouble.enable = true;
      null-ls.enable = true;
      otter-nvim.enable = true;

      inlayHints.enable = true;
      formatOnSave = true;
    };

    autocomplete = {
      enableSharedCmpSources = true;

      blink-cmp = {
        enable = true;
        setupOpts.cmdline.keymap.preset = "default";
        sourcePlugins = {
          ripgrep.enable = true;
          emoji.enable = true;
          spell.enable = true;
        };
        friendly-snippets.enable = true;
      };
    };

    mini = {
      trailspace.enable = true;
      comment.enable = true;
      cursorword.enable = true;
      move.enable = true;
      operators.enable = true;
      pairs.enable = true;
      surround.enable = true;
      splitjoin.enable = true;

      git.enable = true;

      tabline.enable = true;
      statusline.enable = true;
      icons.enable = true;
      misc.enable = true;
      extra.enable = true;
    };

    treesitter = {
      highlight.enable = true;
      autotagHtml = true;
      fold = true;
      indent.enable = true;
      # context.enable = true;
    };

    notes.todo-comments.enable = true;

    dashboard = {
      alpha.enable = true;
      alpha = {
        theme = "dashboard";
      };
    };

    utility = {
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
    spellcheck = {
      languages = [
        "en"
        # "de"
        # "ru"
      ];
      # spellcheck.programmingWordlist.enable = true;
      ignoredFiletypes = ["toggleterm" "alpha"];
      ignoreTerminal = true;
    };

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
      noice.setupOpts = {
        routes = [
          {
            filter = {
              event = "msg_show";
              kind = "confirm";
              find = "Download regional dictionaries";
            };
            opts = {skip = true;};
          }
        ];
      };
      smartcolumn.enable = true;

      borders.enable = true;
      breadcrumbs.navbuddy.enable = true;
    };

    # tabline.nvimBufferline = {
    #   enable = true;
    #   setupOpts.options = {
    #     indicator.style = "none";
    #     numbers = "none";
    #   };
    #   mappings = {
    #     closeCurrent = "<leader>x";
    #     cycleNext = "<Tab>";
    #     cyclePrevious = "<S-Tab>";
    #     moveNext = "<leader><Tab>";
    #     movePrevious = "<leader><S-Tab>";
    #   };
    # };
    # statusline.lualine.enable = true;

    visuals = {
      nvim-web-devicons.enable = true;
      nvim-scrollbar.enable = true;
    };

    clipboard.enable = true;
    clipboard.providers.wl-copy.enable = true;

    keymaps = [
      {
        mode = "n";
        key = "<leader>q";
        action = "<cmd>bdelete<cr>";
      }
      {
        mode = "n";
        key = "<leader><Tab>";
        action = "<cmd>buffer #<cr>";
      }

      {
        mode = "n";
        key = "<leader><Period>";
        action = "<cmd>IconPickerInsert<CR>";
      }
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
        mode = ["n" "t"];
        key = "<C-Left>";
        action = "<cmd>wincmd h<CR>";
      }
      {
        mode = ["n" "t"];
        key = "<C-Down>";
        action = "<cmd>wincmd j<CR>";
      }
      {
        mode = ["n" "t"];
        key = "<C-Up>";
        action = "<cmd>wincmd k<CR>";
      }
      {
        mode = ["n" "t"];
        key = "<C-Right>";
        action = "<cmd>wincmd l<CR>";
      }

      {
        mode = "n";
        key = "<leader>w";
        action = "<cmd>w<CR>";
      }
      {
        mode = ["n" "i" "v" "c"];
        key = "<MiddleMouse>";
        action = "<Nop>";
        desc = "Disable middle mouse paste";
      }
      {
        mode = ["n" "i" "v" "c"];
        key = "<2-MiddleMouse>";
        action = "<Nop>";
        desc = "Disable middle mouse double-click paste";
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
      foldlevel = 99;
      foldlevelstart = 99;
    };

    globals.mapleader = " ";
    viAlias = true;
    vimAlias = true;
  };
}
