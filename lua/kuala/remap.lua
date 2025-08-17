vim.g.mapleader = " "

vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
vim.keymap.set("n", "<leader>o", "<C-w>")
vim.keymap.set("n", "|", "<cmd>Neotree toggle<cr>")
vim.keymap.set("n", "<leader>|", "<cmd>Neotree toggle<cr>")
vim.keymap.set("n", "<leader>bb", "<cmd>Neotree toggle show buffers right<cr>")
vim.keymap.set("n", "<leader>bg", "<cmd>Neotree float git_status<cr>")

vim.keymap.set("n", "=", [[<cmd>vertical resize +5<cr>]]) -- make the window biger vertically
vim.keymap.set("n", "+", [[<cmd>vertical resize -5<cr>]]) -- make the window smaller vertically
vim.keymap.set("n", "-", [[<cmd>horizontal resize +2<cr>]]) -- make the window bigger horizontally by pressing shift and =
vim.keymap.set("n", "_", [[<cmd>horizontal resize -2<cr>]]) -- make the window smaller horizontally by pressing shift and -
vim.keymap.set("n", "<leader>sr", ":%s/g<Left>", { desc = "Search and replace" })

vim.keymap.set("n", "<leader>w", "<cmd>wa<cr>")

vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
--- vim.keymap.set("n", "n", "nzzzv")
--- vim.keymap.set("n", "N", "Nzzzv")

-- greatest remap ever
vim.keymap.set("x", "<leader>p", [["_dP]])

-- next greatest remap ever : asbjornHaland
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

-- void
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])

vim.keymap.set("n", "Q", "<nop>")
vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")

-- format keybind on formating.lua now
-- vim.keymap.set("n", "<leader>fo", vim.lsp.buf.format)

vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

vim.keymap.set("n", "<leader>cp", function()
	vim.fn.setreg("+", vim.fn.expand("%:p"))
end, { desc = "Copy file path to clipboard" })

vim.keymap.set("n", "<leader><leader>", function()
	vim.cmd("so")
end)

-- -- codecompanion keybinds
-- vim.keymap.set({ "n", "v" }, "<C-a>", "<cmd>CodeCompanionActions<cr>", { noremap = true, silent = true })
-- vim.keymap.set({ "n", "v" }, "<leader>aa", "<cmd>CodeCompanionChat Toggle right<cr>", { noremap = true, silent = true })
-- vim.keymap.set("v", "ga", "<cmd>CodeCompanionChat Add<cr>", { noremap = true, silent = true })
--
-- -- Expand 'cc' into 'CodeCompanion' in the command line
-- vim.cmd([[cab cc CodeCompanion]])
