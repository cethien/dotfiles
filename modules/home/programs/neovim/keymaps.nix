{
  programs.nixvim.keymaps = [
    {
      mode = "n";
      key = "<leader>q";
      action = "<cmd>quit<CR>";
    }
    {
      mode = "n";
      key = "<leader>qq";
      action = "<cmd>quitall<CR>";
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
  ];
}
