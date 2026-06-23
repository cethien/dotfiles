vim.g.mapleader = " "

vim.o.tabstop = 2
vim.o.shiftwidth = 0

vim.keymap.set("n", "<leader>/", "<cmd>noh<CR>", { desc = "Clear Search Highlight" })

vim.keymap.set("v", "<leader>y", '"+y', { desc = "Copy to System Clipboard" })
vim.keymap.set("v", "<leader>p", '"+p', { desc = "Paste from System Clipboard" })

vim.keymap.set("t", "<C-n>", [[<C-\><C-n>]], { noremap = true })

local win_modes = { "n", "t" }
vim.keymap.set(win_modes, "<C-Left>", "<cmd>wincmd h<CR>")
vim.keymap.set(win_modes, "<C-Down>", "<cmd>wincmd j<CR>")
vim.keymap.set(win_modes, "<C-Up>", "<cmd>wincmd k<CR>")
vim.keymap.set(win_modes, "<C-Right>", "<cmd>wincmd l<CR>")

local mouse_modes = { "n", "i", "v", "c" }
vim.keymap.set(mouse_modes, "<MiddleMouse>", "<Nop>")
vim.keymap.set(mouse_modes, "<2-MiddleMouse>", "<Nop>")

require("mini.basics").setup()
require("mini.misc").setup()
require("mini.move").setup({
	mappings = {
		left = "<A-Left>",
		right = "<A-Right>",
		down = "<A-Down>",
		up = "<A-Up>",

		line_left = "<A-Left>",
		line_right = "<A-Right>",
		line_down = "<A-Down>",
		line_up = "<A-Up>",
	},
})

require("mini.comment").setup()
require("mini.operators").setup()
require("mini.align").setup()
require("mini.pairs").setup()
require("mini.surround").setup()
require("mini.ai").setup()
require("mini.splitjoin").setup()

local mini_buf = require("mini.bufremove")
mini_buf.setup({})
vim.keymap.set("n", "<Leader>q", function()
	mini_buf.delete(0, false)
end, { desc = "Delete buffer keeping layout" })
vim.keymap.set("n", "<tab>", "<cmd>bnext<cr>", { desc = "next buffer" })
vim.keymap.set("n", "<s-tab>", "<cmd>bprevious<cr>", { desc = "prev buffer" })

local mini_files = require("mini.files")
mini_files.setup({
	mappings = {
		go_in = "<Right>",
		go_in_plus = "<Return>",
		go_out = "<Left>",
		go_out_plus = "",
	},
})
vim.keymap.set("n", "<leader>e", function()
	local current_file = vim.api.nvim_buf_get_name(0)

	if current_file == "" then
		mini_files.open(vim.fn.getcwd())
	else
		mini_files.open(current_file)
	end
end, { desc = "Open File Tree (Current File)" })

local pick = require("mini.pick")
pick.setup()
require("mini.extra").setup()
vim.keymap.set("n", "<leader><Space>", pick.builtin.files, { desc = "Find Files" })
vim.keymap.set("n", "<leader>fg", pick.builtin.grep_live, { desc = "Live Grep" })
vim.keymap.set("n", "<leader>fb", pick.builtin.buffers, { desc = "Buffers" })
vim.keymap.set("n", "<leader>hh", pick.builtin.help, { desc = "Help Tags" })

require("auto-session").setup()
require("scope").setup()

require("toggleterm").setup({
	open_mapping = [[<c-t>]],
})

require("csvview").setup({})
require("lorem").setup({})

require("nvim_sops").setup({
	defaults = { ageKeyFile = "$HOME/.sops/age/keys.txt" },
})
vim.keymap.set("n", "<leader>ef", vim.cmd.SopsEncrypt, { desc = "[E]ncrypt [F]ile" })
vim.keymap.set("n", "<leader>df", vim.cmd.SopsDecrypt, { desc = "[D]ecrypt [F]ile" })

-- git/vcs
require("octo").setup({
	picker = "default",
	picker_config = {
		use_emojis = true,
	},
})
vim.keymap.set("n", "<leader>oi", "<cmd>Octo issue list<CR>", { desc = "Show issues" })
vim.keymap.set("n", "<leader>op", "<cmd>Octo pr list<CR>", { desc = "Show PRs" })
vim.keymap.set("n", "<leader>od", "<cmd>Octo discussion list<CR>", { desc = "Show discussions" })

local git = require("mini.git")
git.setup()
require("mini.diff").setup()

-- vim.keymap.set("n", "<leader>gg", fzf.git_status, { desc = "Git Status" })
-- vim.keymap.set("n", "<leader>gw", fzf.git_worktrees, { desc = "Git Worktrees" })
