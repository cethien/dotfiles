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

vim.lsp.enable("marksman")

vim.lsp.enable("bashls")
vim.lsp.enable("yamlls")
vim.lsp.enable("jsonls")
vim.lsp.enable("lemminx") -- XML
vim.lsp.enable("taplo") -- TOML

vim.lsp.enable("pyright") -- Python
vim.lsp.enable("ansiblels")
vim.lsp.enable("docker_language_server")
vim.lsp.enable("nixd")
vim.lsp.enable("lua_ls")

vim.lsp.enable("html")
vim.lsp.enable("cssls")
vim.lsp.enable("ts_ls")
vim.lsp.enable("eslint")
vim.lsp.enable("emmet_language_server")
vim.lsp.enable("tailwindcss")

require("conform").setup({
	format_on_save = {
		timeout_ms = 500,
		lsp_format = "fallback",
	},

	formatters_by_ft = {
		python = { "ruff_format" },
		nix = { "alejandra" },
		lua = { "stylua" },

		markdown = { "prettierd" },
		html = { "prettierd" },
		css = { "prettierd" },
		javascript = { "prettierd" },
		typescript = { "prettierd" },

		sh = { "shfmt" },
		bash = { "shfmt" },
		json = { "prettierd" },
		yaml = { "prettierd" },
		toml = { "taplo" },
	},
})
