return {
	{
		"nvim-telescope/telescope.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			require("telescope").setup({
				defaults = {
					pickers = {
						find_files = {
							hidden = true,
						},
					},
					sorting_strategy = "ascending",
					layout_config = {
						-- mirror = true
						prompt_position = "top",
					},
				},
			})

			local builtin = require("telescope.builtin")
			vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
			vim.keymap.set("n", "<C-p>", builtin.git_files, {})
			vim.keymap.set("n", "<leader>fws", function()
				local word = vim.fn.expand("<cword>")
				builtin.grep_string({ search = word })
			end)
			vim.keymap.set("n", "<leader>fWs", function()
				local word = vim.fn.expand("<cWORD>")
				builtin.grep_string({ search = word })
			end)
			vim.keymap.set("n", "<leader>fs", function()
				builtin.grep_string({ search = vim.fn.input("Grep > ") })
			end)
			vim.keymap.set("n", "<leader>vh", builtin.help_tags, {})
		end,
		-- lazy = false,
	},
	-- {
	-- 	"nvim-telescope/telescope-file-browser.nvim",
	-- 	dependencies = { "nvim-lua/plenary.nvim" },
	-- 	config = function()
	-- 		local fb_actions = require("telescope").extensions.file_browser.actions
	--
	-- 		require("telescope").setup({
	-- 			extensions = {
	-- 				file_browser = {
	-- 					hidden = { file_browser = true, folder_browser = true },
	-- 					mappings = {
	-- 						["i"] = {
	-- 							["<C-T>"] = fb_actions.create,
	-- 							["<C-D>"] = fb_actions.remove,
	-- 						},
	-- 					},
	--
	-- 					-- disables netrw and use telescope-file-browser in its place
	-- 					hijack_netrw = true,
	-- 				},
	-- 			},
	-- 		})
	--
	-- 		-- To get telescope-file-browser loaded and working with telescope,
	-- 		-- you need to call load_extension, somewhere after setup function:
	-- 		require("telescope").load_extension("file_browser")
	--
	-- 		vim.keymap.set("n", "<space>fb", ":Telescope file_browser<CR>")
	-- 		-- open file_browser with the path of the current buffer
	-- 		vim.keymap.set("n", "<space>ft", ":Telescope file_browser path=%:p:h select_buffer=true<CR>")
	-- 		-- vim.keymap.set("n", "<space>fd", telescope.file_browser.finders.finder())
	-- 	end,
	-- },
}
