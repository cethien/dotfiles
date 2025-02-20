{ lib, config, inputs, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.deeznuts.programs.neovim;
in
{
  imports = [
    inputs.nixvim.homeManagerModules.nixvim
  ];

  options.deeznuts.programs.neovim = {
    enable = mkEnableOption "Enable neovim";
  };

  config = mkIf cfg.enable {
    home.shellAliases.v = "nvim";

    programs.nixvim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;

      globalOpts = {
        number = true;
        signcolumn = "yes";
        mouse = "a";

        # Search
        ignorecase = true;
        smartcase = true;

        # Configure how new splits should be opened
        splitright = true;
        splitbelow = true;

        list = true;
      };

      globals = {
        mapleader = " ";
      };

      colorschemes.catppuccin.enable = true;

      plugins = {
        web-devicons.enable = true;
        lualine.enable = true;
        bufferline.enable = true;
        dropbar.enable = true;
        image.enable = true;
        overseer.enable = true;
        blink-cmp.enable = true;
        commentary.enable = true;
        dap.enable = true;
        cursorline.enable = true;
        telescope.enable = true;
        # neo-tree.enable = true;
        oil.enable = true;
        gx.enable = true;

        direnv.enable = true;
        nix.enable = true;
        nix-develop.enable = true;

        # hex.enable = true;

        lazygit.enable = true;
        yazi.enable = true;

        vim-css-color.enable = true;
        todo-comments.enable = true;

        schemastore.enable = true;

        autoclose.enable = true;

        treesitter.enable = true;
        rest.enable = true;

        persistence.enable = true;

        lsp-format.enable = true;
        lsp = {
          enable = true;
          servers = {
            nil_ls = {
              enable = true;

              settings.formatting.command = [
                "nixpkgs-fmt"
              ];
            };
            bashls.enable = true;

            yamlls.enable = true;
            jsonls.enable = true;

            dockerls.enable = true;

            sqls.enable = true;

            lua_ls.enable = true;

            html.enable = true;
            ts_ls.enable = true;
            eslint.enable = true;
            cssls.enable = true;
            htmx.enable = true;
            tailwindcss.enable = true;
            svelte.enable = true;

            gopls.enable = true;
            templ.enable = true;
          };
        };
      };

      keymaps = [
        {
          key = "<leader>g";
          action = "<cmd>LazyGit<cr>";
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
          key = "<C-s>";
          action = "<cmd>write<CR>";
        }

        {
          mode = "n";
          key = "<leader><Space>";
          action = "<cmd>Telescope find_files<cr>";
        }

        {
          mode = "n";
          key = "<C-c>";
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
        {
          mode = "n";
          key = "<leader>w";
          action = "<cmd>bdelete<cr>";
          options = {
            desc = "Delete buffer";
          };
        }

        {
          mode = "n";
          key = "<leader>t";
          action = "<cmd>terminal<cr>";
          options = {
            desc = "open terminal";
          };
        }
      ];

    };
  };
}
