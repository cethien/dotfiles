{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  cfg = config.programs.gh;
in {
  config = mkIf cfg.enable {
    programs.neovim = {
      plugins = [pkgs.vimPlugins.octo-nvim];
      initLua =
        # lua
        ''
          require("octo").setup({
          	picker = "default",
          	picker_config = {
          		use_emojis = true,
          	},
          })
          vim.keymap.set("n", "<leader>oi", "<cmd>Octo issue list<CR>", { desc = "Show issues" })
          vim.keymap.set("n", "<leader>or", "<cmd>Octo review<CR>", { desc = "Show issues" })
          vim.keymap.set("n", "<leader>op", "<cmd>Octo pr list<CR>", { desc = "Show PRs" })
          vim.keymap.set("n", "<leader>od", "<cmd>Octo discussion list<CR>", { desc = "Show discussions" })
        '';
    };
  };
}
