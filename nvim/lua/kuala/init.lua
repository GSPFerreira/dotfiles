require("kuala.lazy")
require("kuala.remap")
require("kuala.set")
--- require("config.kclconfig")
local augroup = vim.api.nvim_create_augroup
local kuala = augroup("kuala", {})
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

vim.g.netrw_browse_split = 0
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 25

-- Auto-read files when they change externally
vim.opt.autoread = true

-- Auto-reload on focus/buffer enter
autocmd({"FocusGained", "BufEnter"}, {
	group = kuala,
	pattern = "*",
	command = "checktime"
})

-- Check for changes on cursor hold (optional)
autocmd({"CursorHold", "CursorHoldI"}, {
	group = kuala,
	pattern = "*",
	command = "checktime"
})

-- Reduce update time for faster checks (optional, default is 4000ms)
vim.opt.updatetime = 300

-- Quit Neovim if neo-tree is the last window
autocmd("QuitPre", {
	group = kuala,
	callback = function()
		local tree_wins = {}
		local floating_wins = {}
		local wins = vim.api.nvim_list_wins()
		for _, w in ipairs(wins) do
			local bufname = vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(w))
			if bufname:match("neo%-tree") ~= nil then
				table.insert(tree_wins, w)
			end
			if vim.api.nvim_win_get_config(w).relative ~= "" then
				table.insert(floating_wins, w)
			end
		end
		if #wins - #floating_wins - #tree_wins == 1 then
			for _, w in ipairs(tree_wins) do
				vim.api.nvim_win_close(w, true)
			end
		end
	end,
})
