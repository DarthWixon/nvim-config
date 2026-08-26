-- set leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- default options
local opts = { noremap = true, silent = true }

-- neotree
vim.keymap.set("n", "<leader>e", ":Neotree float toggle<CR>", opts)

-- delete single character without copying into register
vim.keymap.set("n", "x", '"_x', opts)

-- Buffers
vim.keymap.set("n", "<Tab>", ":bnext<CR>", opts)
vim.keymap.set("n", "<S-Tab>", ":bprevious<CR>", opts)
vim.keymap.set("n", "<leader>q", ":Bdelete!<CR>", opts) -- close buffer
vim.keymap.set("n", "<leader>n", "<cmd> enew <CR>", opts) -- new buffer

-- Window management
vim.keymap.set("n", "<leader>v", "<C-w>v", opts) -- split window vertically
vim.keymap.set("n", "<leader>h", "<C-w>s", opts) -- split window horizontally
vim.keymap.set("n", "<leader>se", "<C-w>=", opts) -- make split windows equal width & height
vim.keymap.set("n", "<leader>xs", ":close<CR>", opts) -- close current split window

-- Navigate between splits
vim.keymap.set("n", "<C-k>", ":wincmd k<CR>", opts)
vim.keymap.set("n", "<C-j>", ":wincmd j<CR>", opts)
vim.keymap.set("n", "<C-h>", ":wincmd h<CR>", opts)
vim.keymap.set("n", "<C-l>", ":wincmd l<CR>", opts)

-- Keep last yanked when pasting
vim.keymap.set("v", "p", '"_dP', opts)

-- Explicitly yank to system clipboard (highlighted and entire row)
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

-- Terminal buffer commands
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", opts) -- exit input mode in terminal buffer
vim.keymap.set("n", "<leader>tf", ":ToggleTerm direction=float<CR>", opts) -- toggle floating terminal
vim.keymap.set("n", "<leader>tv", ":ToggleTerm direction=vertical<CR>", opts) -- toggle vertical terminal

-- Copy the :messages history to the system clipboard
vim.api.nvim_create_user_command("MessagesYank", function()
	local messages = vim.fn.execute("messages")
	messages = messages:gsub("^%s*\n", ""):gsub("%s*$", "")
	if messages == "" then
		vim.notify("No messages to copy", vim.log.levels.WARN)
		return
	end
	vim.fn.setreg("+", messages .. "\n")
	local lines = select(2, messages:gsub("\n", "")) + 1
	vim.notify(("Copied %d message line%s to the clipboard"):format(lines, lines == 1 and "" or "s"))
end, { desc = "Copy :messages output to the system clipboard" })

vim.keymap.set("n", "<leader>m", ":MessagesYank<CR>", opts) -- copy :messages to clipboard
