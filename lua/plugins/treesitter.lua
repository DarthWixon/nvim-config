-- Highlight, edit, and navigate code
local languages = {
	"lua",
	"python",
	"vimdoc",
	"vim",
	"regex",
	"terraform",
	"sql",
	"dockerfile",
	"toml",
	"json",
	"gitignore",
	"yaml",
	"make",
	"cmake",
	"markdown",
	"markdown_inline",
	"bash",
	"tsx",
}

return {
	"nvim-treesitter/nvim-treesitter",
	branch = "main",
	build = ":TSUpdate",
	lazy = false,
	priority = 1000,

	dependencies = {
		{
			"nvim-treesitter/nvim-treesitter-textobjects",
			branch = "main",
		},
	},

	config = function()
		local treesitter = require("nvim-treesitter")

		treesitter.setup()

		-- Installs missing parsers asynchronously.
		-- This is a no-op for parsers that are already installed.
		treesitter.install(languages)

		-- Enable highlighting and indentation whenever a parser exists.
		vim.api.nvim_create_autocmd("FileType", {
			group = vim.api.nvim_create_augroup("treesitter-start", { clear = true }),
			callback = function(args)
				local ok = pcall(vim.treesitter.start, args.buf)

				if ok then
					vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
				end
			end,
		})

		-- Incremental selection is now built into Neovim.
		vim.keymap.set({ "n", "x" }, "<C-Space>", function()
			vim.treesitter.select("parent")
		end, { desc = "Select parent syntax node" })

		vim.keymap.set("x", "<M-Space>", function()
			vim.treesitter.select("child")
		end, { desc = "Select child syntax node" })

		-- Text-object configuration
		require("nvim-treesitter-textobjects").setup({
			select = {
				lookahead = true,
			},
			move = {
				set_jumps = true,
			},
		})

		local function map_select(lhs, capture)
			vim.keymap.set({ "x", "o" }, lhs, function()
				require("nvim-treesitter-textobjects.select").select_textobject(capture, "textobjects")
			end)
		end

		map_select("aa", "@parameter.outer")
		map_select("ia", "@parameter.inner")
		map_select("af", "@function.outer")
		map_select("if", "@function.inner")
		map_select("ac", "@class.outer")
		map_select("ic", "@class.inner")

		local function map_move(lhs, method, capture)
			vim.keymap.set({ "n", "x", "o" }, lhs, function()
				require("nvim-treesitter-textobjects.move")[method](capture, "textobjects")
			end)
		end

		map_move("]m", "goto_next_start", "@function.outer")
		map_move("]]", "goto_next_start", "@class.outer")
		map_move("]M", "goto_next_end", "@function.outer")
		map_move("][", "goto_next_end", "@class.outer")

		map_move("[m", "goto_previous_start", "@function.outer")
		map_move("[[", "goto_previous_start", "@class.outer")
		map_move("[M", "goto_previous_end", "@function.outer")
		map_move("[]", "goto_previous_end", "@class.outer")

		vim.keymap.set("n", "<leader>a", function()
			require("nvim-treesitter-textobjects.swap").swap_next("@parameter.inner")
		end, { desc = "Swap with next parameter" })

		vim.keymap.set("n", "<leader>A", function()
			require("nvim-treesitter-textobjects.swap").swap_previous("@parameter.inner")
		end, { desc = "Swap with previous parameter" })

		vim.filetype.add({
			extension = {
				tf = "terraform",
				tfvars = "terraform",
			},
		})
	end,
}
