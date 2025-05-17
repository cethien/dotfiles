{
  programs.nixvim.keymaps = [
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
      options = {
        noremap = true;
      };
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
      key = "<leader>bd";
      action = "<cmd>bdelete<cr>";
      options = {
        desc = "Delete buffer";
      };
    }

    {
      mode = "n";
      key = "<C-e>";
      action = "<cmd>Oil<CR>";
    }

    {
      mode = "n";
      key = "<leader>gg";
      action = "<cmd>Neogit<cr>";
    }
    {
      mode = "n";
      key = "<leader>gh";
      action = "<cmd>Octo actions<CR>";
    }

    {
      mode = "n";
      key = "<C-q>";
      action = "<cmd>ToggleTerm<CR>";
    }


    {
      mode = "n";
      key = "<leader>db";
      action = "<cmd>DBUIToggle<CR>";
    }

    {
      mode = "n";
      key = "<leader>sr";
      action = "<cmd>SessionRestore<CR>";
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
      mode = [ "n" "v" ];
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
}
