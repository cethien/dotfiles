vim.api.nvim_create_autocmd("FileType", {
	pattern = "*",
	callback = function()
		local buf = vim.api.nvim_get_current_buf()
		local lang = vim.bo[buf].filetype

		if lang == "" or vim.bo[buf].buftype ~= "" then
			return
		end

		local has_parser = pcall(vim.treesitter.get_parser, buf, lang)
		if has_parser then
			pcall(vim.treesitter.start, buf, lang)
		end
	end,
})
require("treesitter-context")

vim.lsp.enable("marksman") -- typst
vim.lsp.enable("tinymist") -- typst
vim.lsp.enable("texlab") -- latex

vim.lsp.enable("gopls") -- Go
vim.lsp.enable("templ") -- Templ (Go Web)
vim.lsp.enable("pyright") -- Python
vim.lsp.enable("rust_analyzer") -- Rust
vim.lsp.enable("omnisharp") -- C#
vim.lsp.enable("clangd") -- C/C++
vim.lsp.enable("jdtls") -- Java
vim.lsp.enable("qmlls")

vim.lsp.enable("html")
vim.lsp.enable("cssls")
vim.lsp.enable("ts_ls")
vim.lsp.enable("eslint")
vim.lsp.enable("emmet_language_server")
vim.lsp.enable("tailwindcss")
vim.lsp.enable("astro")
vim.lsp.enable("svelteserver")
vim.lsp.enable("vue_ls") -- Vue

vim.lsp.enable("sqls")

vim.lsp.enable("just")
vim.lsp.enable("ansiblels")
vim.lsp.enable("docker_language_server")
vim.lsp.enable("helm_ls")
vim.lsp.enable("terraformls")
vim.lsp.enable("nixd")
vim.lsp.enable("lua_ls")

vim.lsp.enable("bashls")
vim.lsp.enable("yamlls")
vim.lsp.enable("jsonls")
vim.lsp.enable("lemminx") -- XML
vim.lsp.enable("taplo") -- TOML

vim.filetype.add({
	filename = {
		["Caddyfile"] = "caddyfile",
		["Corefile"] = "corefile",
	},
	extension = {
		["caddyfile"] = "caddyfile",
		["corefile"] = "corefile",
	},
})

vim.lsp.config("caddy_ls", {
	cmd = { "caddy-language-server" },
	filetypes = { "caddyfile", "corefile" },
	root_markers = { "Caddyfile", "Corefile", ".git" },
	settings = {},
})

vim.lsp.enable("caddy_ls")

-- require("otter").setup()

require("conform").setup({
	format_on_save = {
		timeout_ms = 500,
		lsp_format = "fallback",
	},

	formatters_by_ft = {
		typst = { "typstfmt" },

		go = { "gofumpt", "goimports" },
		templ = { "templ" },
		python = { "ruff_format" },
		rust = { "rustfmt" },
		c = { "clang-format" },
		cpp = { "clang-format" },
		just = { "just" },

		nix = { "alejandra" },
		lua = { "stylua" },

		markdown = { "prettierd" },
		html = { "prettierd" },
		css = { "prettierd" },
		javascript = { "prettierd" },
		typescript = { "prettierd" },
		astro = { "prettierd" },
		svelte = { "prettierd" },
		vue = { "prettierd" },

		sh = { "shfmt" },
		bash = { "shfmt" },
		json = { "prettierd" },
		yaml = { "prettierd" },
		toml = { "taplo" },

		caddyfile = { "caddy_fmt" },
		corefile = { "caddy_fmt" },
	},

	formatters = {
		caddy_fmt = {
			command = "caddy",
			args = { "fmt", "-" },
		},
	},
})

require("go").setup()
require("crates").setup()
