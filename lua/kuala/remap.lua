vim.g.mapleader = " "

vim.api.nvim_set_keymap("n", ";", "n", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
vim.keymap.set("n", "<leader>o", "<C-w>")
vim.keymap.set("n", "|", "<cmd>Neotree reveal<cr>")
vim.keymap.set("n", "<leader>bb", "<cmd>Neotree toggle show buffers right<cr>")
vim.keymap.set("n", "<leader>bg", "<cmd>Neotree float git_status<cr>")

vim.keymap.set("n", "<leader>on", "<C-w>j")
vim.keymap.set("n", "<leader>oe", "<C-w>k")
vim.keymap.set("n", "<leader>oj", "<C-w>n")
vim.keymap.set("n", "<leader>ok", "<C-w>e")
vim.keymap.set("n", "=", [[<cmd>vertical resize +5<cr>]]) -- make the window biger vertically
vim.keymap.set("n", "+", [[<cmd>vertical resize -5<cr>]]) -- make the window smaller vertically
vim.keymap.set("n", "-", [[<cmd>horizontal resize +2<cr>]]) -- make the window bigger horizontally by pressing shift and =
vim.keymap.set("n", "_", [[<cmd>horizontal resize -2<cr>]]) -- make the window smaller horizontally by pressing shift and -
vim.keymap.set("n", "<leader>sr", [[<cmd>:%s/\%]]) -- make the window smaller horizontally by pressing shift and -

vim.keymap.set({ "n", "v", "o" }, "n", "j")
vim.keymap.set({ "n", "v", "o" }, "j", "e")
vim.keymap.set({ "n", "v", "o" }, "e", "k")
vim.keymap.set({ "n", "v", "o" }, "N", "J")
vim.keymap.set({ "n", "v", "o" }, "E", "K")
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

vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

vim.keymap.set("n", "<leader><leader>", function()
	vim.cmd("so")
end)
