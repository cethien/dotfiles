{
  programs.nixvim = {
    plugins = {
      auto-session.enable = true;

      transparent.enable = true;
      web-devicons.enable = true;
      lualine.enable = true;
      bufferline.enable = true;
      dropbar.enable = true;
      image.enable = true;
      overseer.enable = true;
      blink-cmp.enable = true;
      commentary.enable = true;
      cursorline.enable = true;
      telescope = {
        enable = true;
        settings = {
          defaults = {
            file_ignore_patterns = [
              "^.git/"
              "^node_modules"
              "^.direnv"
            ];
          };
        };
      };
      toggleterm = {
        enable = true;
        settings = {
          direction = "float";
        };
      };
      oil.enable = true;
      gx.enable = true;
      yanky.enable = true;
      markview.enable = true;


      direnv.enable = true;
      nix.enable = true;
      nix-develop.enable = true;

      # hex.enable = true;

      lazygit.enable = true;
      octo.enable = true;
      yazi.enable = true;

      dap.enable = true;

      vim-css-color.enable = true;
      todo-comments.enable = true;

      schemastore.enable = true;

      autoclose.enable = true;

      treesitter.enable = true;
      rest.enable = true;

      vim-dadbod.enable = true;
      vim-dadbod-completion.enable = true;
      vim-dadbod-ui.enable = true;

      lsp-format.enable = true;
      lsp.enable = true;
    };

    keymaps = [
      {
        mode = "n";
        key = "<leader>e";
        action = "<cmd>Oil<CR>";
      }

      {
        mode = "n";
        key = "<leader>yy";
        action = "<cmd>Yazi<CR>";
      }

      {
        mode = "n";
        key = "<leader>g";
        action = "<cmd>LazyGit<cr>";
      }

      {
        mode = "n";
        key = "<leader>gh";
        action = "<cmd>Octo actions<CR>";
      }

      {
        mode = "n";
        key = "<leader>t";
        action = "<cmd>ToggleTerm<CR>";
      }

      {
        mode = "n";
        key = "<leader>db";
        action = "<cmd>DBUIToggle<CR>";
      }

      {
        mode = "n";
        key = "<leader>or";
        action = "<cmd>OverseerRun<cr>";
      }
      {
        mode = "n";
        key = "<leader>o";
        action = "<cmd>OverseerToggle<cr>";
      }

      {
        mode = "n";
        key = "<leader><Space>";
        action = "<cmd>Telescope find_files<cr>";
      }
      {
        mode = "n";
        key = "<leader>p";
        action = "<cmd>Telescope commands<CR>";
      }
      {
        mode = "n";
        key = "<leader>fg";
        action = "<cmd>Telescope live_grep<CR>";
      }

      {
        mode = "n";
        key = "<leader>cc";
        action = "<cmd>Commentary<CR>";
      }

      {
        mode = "n";
        key = "<Tab>";
        action = "<cmd>BufferLineCycleNext<cr>";
        options = {
          desc = "Cycle to next buffer";
        };
      }
      {
        mode = "n";
        key = "<S-Tab>";
        action = "<cmd>BufferLineCyclePrev<cr>";
        options = {
          desc = "Cycle to previous buffer";
        };
      }
    ];
  };
}
