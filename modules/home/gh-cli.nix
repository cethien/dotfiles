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
    sops.secrets."gh_token" = {};
    home.sessionVariables.GH_TOKEN = "$(cat ${config.sops.secrets."gh_token".path})";

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

          vim.keymap.set("n", "<leader>os", function()
          	vim.ui.input({ prompt = "Octo Search: " }, function(input)
          		if not input or input == "" then
          			return
          		end

          		vim.cmd("Octo search " .. input)
          	end)
          end, { desc = "Interactive Octo Search" })
        '';
    };
  };
}
