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
      key = "<C-s>";
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
      key = "<C-w>";
      action = "<cmd>bdelete<cr>";
      options = {
        desc = "Delete buffer";
      };
    }

  ];
}
