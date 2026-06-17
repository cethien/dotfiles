vim.g.mapleader = " "

require("auto-session").setup({})

require("mini.misc").setup({})
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

require("mini.comment").setup({})
require("mini.operators").setup({})
require("mini.align").setup({})
require("mini.pairs").setup({})
require("mini.surround").setup({})
require("mini.ai").setup({})
require("mini.splitjoin").setup({})

local mini_files = require("mini.files")
mini_files.setup({
	mappings = {
		go_in = "<Right>",
		go_in_plus = "",
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

local fzf = require("fzf-lua")
fzf.setup({
	winopts = {
		height = 0.8,
		width = 0.9,
		-- preview = { layout = "vertical" },
	},
	file_ignore_patterns = {
		"node_modules",
		"%.git/",
		"%.direnv/",
		"dist/",
		"build/",
		"target/",
		"result/",
	},
	git = {
		worktrees = {
			actions = {
				["ctrl-a"] = false,
				["ctrl-w"] = {
					fn = function(...)
						require("fzf-lua").actions.git_worktree_add(...)
					end,
					header = "add worktree",
					reload = true,
				},
			},
		},
	},
})
vim.keymap.set("n", "<leader><Space>", fzf.files, { desc = "Find Files" })
vim.keymap.set("n", "<leader>fb", fzf.buffers, { desc = "Buffers" })
vim.keymap.set("n", "<leader>fg", fzf.live_grep, { desc = "Live Grep" })
vim.keymap.set("n", "<leader>hh", fzf.help_tags, { desc = "Help Tags" })

vim.keymap.set("n", "<leader>w", "<cmd>w<CR>", { desc = "Save File" })
vim.keymap.set("n", "<leader>q", "<cmd>bdelete<CR>", { desc = "Delete Buffer" })
vim.keymap.set("n", "<leader><Tab>", "<cmd>buffer #<CR>", { desc = "Alternate Buffer" })
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

vim.o.tabstop = 2
vim.o.shiftwidth = 0
