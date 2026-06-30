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

-- ============================================================================
-- MINI.FILES SETUP & FRAMEWORK
-- ============================================================================
local mini_files = require("mini.files")
mini_files.setup({
	mappings = {
		go_in = "<Right>",
		go_in_plus = "<Return>",
		go_out = "<Left>",
		go_out_plus = "",
	},
	windows = { max_number = 3, preview = true, width_preview = 80 },
})

-- Framework to flatly register mappings for mini.files
local registered_maps = {}
local function register_mf(keys, desc, action)
	table.insert(registered_maps, { keys = keys, desc = desc, action = action })
end

vim.api.nvim_create_autocmd("User", {
	pattern = "MiniFilesBufferCreate",
	callback = function(args)
		local buf_id = args.data.buf_id
		local function get_path()
			local entry = mini_files.get_fs_entry()
			return entry and entry.path or nil
		end

		for _, map in ipairs(registered_maps) do
			vim.keymap.set("n", map.keys, function()
				map.action(get_path)
			end, { buffer = buf_id, desc = map.desc })
		end
	end,
})

-- [1] Copy absolute path
register_mf("<M-c>", "Copy absolute path", function(get_path)
	local path = get_path()
	if path then
		vim.fn.setreg("+", path)
		vim.notify("Path copied: " .. vim.fn.fnamemodify(path, ":t"))
	end
end)

-- [2] Copy file content as Markdown block
register_mf("<leader>Y", "Copy file content as Markdown block", function(get_path)
	local path = get_path()
	if path and vim.fn.filereadable(path) == 1 then
		local lines = vim.fn.readfile(path)
		local content = table.concat(lines, "\n")
		local relative_path = vim.fn.fnamemodify(path, ":.")
		local ext = vim.fn.fnamemodify(path, ":e")
		if ext == "" then
			ext = "text"
		end

		local formatted = string.format("# %s\n```%s\n%s\n```\n", relative_path, ext, content)
		vim.fn.setreg("+", formatted)
		vim.notify("Markdown block copied to clipboard!")
	else
		vim.notify("Not a readable file", vim.log.levels.WARN)
	end
end)

-- [3] Copy Real File to Wayland Clipboard
register_mf("<leader>yc", "Copy file to system clipboard", function(get_path)
	local path = get_path()
	if not path then
		return
	end

	local uri = "file://" .. path
	local cmd = string.format("echo -n %s | wl-copy -t text/uri-list", vim.fn.shellescape(uri))
	vim.fn.system(cmd)

	if vim.v.shell_error == 0 then
		vim.notify("File copied to OS clipboard: " .. vim.fn.fnamemodify(path, ":t"))
	else
		vim.notify("Failed to copy file to OS clipboard", vim.log.levels.ERROR)
	end
end)

-- [4] Paste Real File from Wayland Clipboard
register_mf("<leader>p", "Paste file from system clipboard", function(get_path)
	local entry = mini_files.get_fs_entry()
	if not entry then
		return
	end

	local dest_dir = entry.fs_type == "directory" and entry.path or vim.fn.fnamemodify(entry.path, ":h")
	local output = vim.fn.system("wl-paste -t text/uri-list")
	if vim.v.shell_error ~= 0 or output == "" then
		vim.notify("No file found in OS clipboard", vim.log.levels.WARN)
		return
	end

	local source_path = output:gsub("^file://", ""):gsub("%s+$", "")
	if vim.fn.filereadable(source_path) == 0 and vim.fn.isdirectory(source_path) == 0 then
		vim.notify("Clipboard path is invalid or unreadable", vim.log.levels.ERROR)
		return
	end

	local filename = vim.fn.fnamemodify(source_path, ":t")
	local dest_path = dest_dir .. "/" .. filename

	local success, err = vim.uv.fs_copyfile(source_path, dest_path)
	if success then
		vim.notify("File pasted from OS: " .. filename)
		mini_files.synchronize()
	else
		vim.notify("Paste failed: " .. tostring(err), vim.log.levels.ERROR)
	end
end)

local function open_files()
	local current_file = vim.api.nvim_buf_get_name(0)
	if current_file == "" then
		mini_files.open(vim.fn.getcwd())
	else
		mini_files.open(current_file)
	end
end

vim.keymap.set("n", "<leader>e", open_files, { desc = "Open File Tree (Current File)" })
-- ============================================================================

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
local git = require("mini.git")
local diff = require("mini.diff")
git.setup()
diff.setup()

vim.keymap.set("n", "<leader>ga", diff.toggle_overlay, { desc = "Git " })
