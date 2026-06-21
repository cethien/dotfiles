require("csvview").setup({})
require("lorem").setup({})

require("nvim_sops").setup({
	defaults = { ageKeyFile = "$HOME/.sops/age/keys.txt" },
})
vim.keymap.set("n", "<leader>ef", vim.cmd.SopsEncrypt, { desc = "[E]ncrypt [F]ile" })
vim.keymap.set("n", "<leader>df", vim.cmd.SopsDecrype, { desc = "[D]ecrypt [F]ile" })

-- git/vcs
require("octo").setup({
	picker = "fzf-lua",
	picker_config = {
		use_emojis = true,
	},
})
vim.keymap.set("n", "<leader>oi", "<cmd>Octo issue list<CR>", { desc = "Show issues" })
vim.keymap.set("n", "<leader>op", "<cmd>Octo pr list<CR>", { desc = "Show PRs" })
vim.keymap.set("n", "<leader>od", "<cmd>Octo discussion list<CR>", { desc = "Show discussions" })

require("mini.git").setup({})
require("mini.diff").setup({})
vim.keymap.set("n", "<leader>gd", "<cmd>Git diff<cr>", { silent = true, desc = "Git Diff" })
vim.keymap.set("n", "<leader>gg", fzf.git_status, { desc = "Git Status" })
vim.keymap.set("n", "<leader>gw", fzf.git_worktrees, { desc = "Git Worktrees" })
