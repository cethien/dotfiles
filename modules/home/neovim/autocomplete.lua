require("blink.cmp").setup({
	keymap = { preset = "enter" },

	appearance = {
		use_nvim_cmp_as_default = true,
		nerd_font_variant = "mono",
	},

	sources = {
		default = {
			"lsp",
			"path",
			"snippets",
			"buffer",
			"env",
			"emoji",
			"nerdfont",
			"qalc",
		},
		per_filetype = {
			markdown = {
				"nixpkgs_maintainers",
				"git",
				"conventional_commits",
			},
			tex = { "latex" },
		},

		providers = {
			env = {
				name = "Env",
				module = "blink-cmp-env",
				--- @type blink-cmp-env.Options
				opts = {
					item_kind = require("blink.cmp.types").CompletionItemKind.Variable,
					show_braces = false,
					show_documentation_window = true,
				},
			},

			emoji = {
				module = "blink-emoji",
				name = "Emoji",
				score_offset = 15,
				opts = {
					insert = true,
					trigger = ":",
				},
			},

			nerdfont = {
				module = "blink-nerdfont",
				name = "Nerd Fonts",
				score_offset = 15,
				opts = {
					insert = true,
					trigger = ":-",
				},
			},

			qalc = {
				module = "blink-cmp-qalc",
				name = "Qalc",
				score_offset = 100,
				opts = {
					trigger = "?",
				},
			},

			nixpkgs_maintainers = {
				module = "blink_cmp_nixpkgs_maintainers",
				name = "nixpkgs maintainers",
				opts = {
					cache_lifetime = 14,
					silent = false,
					nixpkgs_flake_uri = "nixpkgs",
				},
			},

			git = {
				module = "blink-cmp-git",
				name = "Git",
				opts = {},
			},

			conventional_commits = {
				name = "Conventional Commits",
				module = "blink-cmp-conventional-commits",
				enabled = function()
					return vim.bo.filetype == "gitcommit"
				end,
				---@module 'blink-cmp-conventional-commits'
				---@type blink-cmp-conventional-commits.Options
				opts = {},
			},

			latex = {
				name = "Latex",
				module = "blink-cmp-latex",
				opts = {
					insert_command = false,
				},
			},
		},
	},

	-- completion = { ghost_text = { enabled = true } },
})
