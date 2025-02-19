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
    programs.nixvim = {
      enable = true;

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

      colorschemes.catppuccin.enable = true;

      plugins = {
        web-devicons.enable = true;
        lualine.enable = true;
        bufferline.enable = true;

        blink-cmp.enable = true;

        direnv.enable = true;
        nix.enable = true;
        nix-develop.enable = true;

        image.enable = true;

        lazygit.enable = true;
        yazi.enable = true;

        vim-css-color.enable = true;
        todo-comments.enable = true;

        schemastore.enable = true;

        autoclose.enable = true;

        treesitter.enable = true;
        rest.enable = true;

        oil.enable = true;

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
          action = "<cmd>LazyGit<cr>";
          key = "<C-S-g>";
        }
        {
          action = "<cmd>Commentary<CR>";
          key = "<leader>/";
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
          key = "<S-l>";
          action = "<cmd>BufferLineCycleNext<cr>";
          options = {
            desc = "Cycle to next buffer";
          };
        }

        {
          mode = "n";
          key = "<S-h>";
          action = "<cmd>BufferLineCyclePrev<cr>";
          options = {
            desc = "Cycle to previous buffer";
          };
        }

        {
          mode = "n";
          key = "<leader>bd";
          action = "<cmd>bdelete<cr>";
          options = {
            desc = "Delete buffer";
          };
        }
      ];

    };
  };
}
