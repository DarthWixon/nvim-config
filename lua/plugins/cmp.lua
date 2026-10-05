-- Autocompletion from LSP servers. Snippets expand through Neovim's built-in
-- vim.snippet (nvim-cmp's default), so no snippet engine plugin is needed.
return {
	"hrsh7th/nvim-cmp",
	event = "InsertEnter",
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
	},
	config = function()
		local cmp = require("cmp")

		cmp.setup({
			mapping = cmp.mapping.preset.insert({
				["<C-Space>"] = cmp.mapping.complete(),
				-- Only confirm an explicitly selected item, so <CR> still inserts a newline
				["<CR>"] = cmp.mapping.confirm({ select = false }),
			}),
			sources = cmp.config.sources({
				{ name = "nvim_lsp" },
			}),
		})
	end,
}
