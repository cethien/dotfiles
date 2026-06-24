vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.linebreak = true
vim.opt.breakindent = true
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
vim.opt.showmode = false

vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
	callback = function()
		local max_len = 79
		local line_text = vim.api.nvim_get_current_line()
		if vim.fn.strdisplaywidth(line_text) > max_len then
			vim.wo.colorcolumn = "80"
		else
			vim.wo.colorcolumn = ""
		end
	end,
})

vim.diagnostic.config({
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = "󰅚",
			[vim.diagnostic.severity.WARN] = "󰀪",
			[vim.diagnostic.severity.INFO] = "󰋽",
			[vim.diagnostic.severity.HINT] = "󰌶",
		},
	},
})

vim.g.diagnostics_active = true
vim.keymap.set("n", "<leader>td", function()
	if vim.g.diagnostics_active then
		vim.g.diagnostics_active = false
		vim.diagnostic.hide()
		print("Diagnostics: OFF")
	else
		vim.g.diagnostics_active = true
		vim.diagnostic.show()
		print("Diagnostics: ON")
	end
end, { desc = "Toggle Diagnostics" })

vim.o.updatetime = 300
vim.api.nvim_create_autocmd("CursorHold", {
	callback = function()
		if not vim.g.diagnostics_active then
			return
		end

		vim.diagnostic.open_float(nil, {
			focusable = false,
			close_events = {
				"BufLeave",
				"CursorMoved",
				"InsertEnter",
				"FocusLost",
			},
			border = "single",
			source = "always",
			prefix = " ",
		})
	end,
})
vim.keymap.set("n", "<leader>qf", vim.diagnostic.setqflist, {
	desc = "Project Diagnostics to Quickfix",
})

require("tokyonight").setup({
	style = "storm",
	transparent = true,
	styles = {
		sidebars = "transparent",
		floats = "transparent",
	},
	on_highlights = function(hl, c)
		hl.FloatBorder = {
			bg = "none",
			fg = c.border_highlight,
		}
		hl.NormalFloat = { bg = "none" }
	end,
})
vim.cmd([[colorscheme tokyonight]])

require("mini.icons").setup({})

require("mini.notify").setup({
	lsp_progress = { level = "ERROR" },
	window = {
		config = {
			border = "single",
		},
		max_width_share = 0.6,
	},
})
require("mini.input").setup({})
require("mini.tabline").setup({})
require("mini.statusline").setup({})
require("mini.cursorword").setup({})
require("mini.trailspace").setup({})

local hipatterns = require("mini.hipatterns")
hipatterns.setup({
	highlighters = {
		fixme = { pattern = "%f[%w]()FIXME()%f[%W]", group = "MiniHipatternsFixme" },
		hack = { pattern = "%f[%w]()HACK()%f[%W]", group = "MiniHipatternsHack" },
		todo = { pattern = "%f[%w]()TODO()%f[%W]", group = "MiniHipatternsTodo" },
		note = { pattern = "%f[%w]()NOTE()%f[%W]", group = "MiniHipatternsNote" },
		hex_color = hipatterns.gen_highlighter.hex_color(),
	},
})

-- tiny_cmdline
vim.opt.cmdheight = 0
require("vim._core.ui2").enable({})
local tiny_cmdline = require("tiny-cmdline")
tiny_cmdline.setup({
	winopts = {
		border = "rounded",
	},
	on_reposition = tiny_cmdline.adapters.blink,
})
