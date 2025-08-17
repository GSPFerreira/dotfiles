require("kuala.lazy")
require("kuala.remap")
require("kuala.set")
--- require("config.kclconfig")
local augroup = vim.api.nvim_create_augroup
local kuala = augroup("kuala", {})
local augroup = vim.api.nvim_create_augroup


local autocmd = vim.api.nvim_create_autocmd
local yank_group = augroup("HighlightYank", {})

function R(name)
	require("plenary.reload").reload_module(name)
end

vim.filetype.add({
	extension = {
		templ = "templ",
	},
})

autocmd("TextYankPost", {
	group = yank_group,
	pattern = "*",
	callback = function()
		vim.highlight.on_yank({
			higroup = "IncSearch",
			timeout = 40,
		})
	end,
})

autocmd({ "BufWritePre" }, {
	group = kuala,
	pattern = "*",
	command = [[%s/\s\+$//e]],
})

autocmd({ "FileType" }, {
	pattern = "markdown",
	callback = function()
		vim.opt_local.conceallevel = 2
		vim.opt_local.concealcursor = "nc"
	end,
})

autocmd("BufRead", {
	pattern = "*.md",
	callback = function()
		local path = vim.fn.expand("%:p")
		local vault_path = vim.fn.expand("~/Documents/Obsidian Vault")
		if vim.startswith(path, vault_path) then
			require("render-markdown").buf_disable()
		end
	end,
})

vim.g.netrw_browse_split = 0
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 25
