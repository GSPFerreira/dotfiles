return {
	{
		"mrcjkb/rustaceanvim",
		version = "^6", -- Recommended
		lazy = false, -- This plugin is already lazy
	},
	{ "nvim-neotest/nvim-nio" },
	{
		"nvim-neotest/neotest",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"antoinemadec/FixCursorHold.nvim",
			"nvim-treesitter/nvim-treesitter",
			"nvim-neotest/neotest-plenary",
			{ "fredrikaverpil/neotest-golang", version = "*" },
			"nsidorenco/neotest-vstest",
		},
		config = function()
			local neotest = require("neotest")
			neotest.setup({
				adapters = {
					require("neotest-plenary"),
					require("neotest-golang"),
					require("neotest-vstest"),
					require("rustaceanvim.neotest")({
						root = function(path)
							return require("neotest.lib").files.match_root_pattern("Cargo.toml", "Cargo.lock")(path)
						end,
					}),
				},
				discovery = {
					-- Enable searching for test files in subdirectories
					enabled = true,
					-- Increase concurrent workers for faster discovery
					concurrent = 1,
				},
				running = {
					-- Also run tests with increased concurrency
					concurrent = true,
				},
			})

			-- -- Autocommand to refresh neotest when entering a Rust file
			-- -- This helps when opening nvim from a parent directory
			-- vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
			-- 	pattern = "*.rs",
			-- 	callback = function()
			-- 		-- Small delay to ensure rust-analyzer is ready
			-- 		vim.defer_fn(function()
			-- 			-- Check if rust-analyzer is attached
			-- 			-- Using the non-deprecated API
			-- 			local clients = vim.lsp.get_clients({ name = "rust_analyzer" })
			-- 			if #clients > 0 then
			-- 				local current_file = vim.fn.expand("%:p")
			-- 				if current_file and current_file ~= "" then
			-- 					-- Use the state adapter tree which forces discovery
			-- 					local ok, _ = pcall(function()
			-- 						-- This will force neotest to build the test tree
			-- 						return neotest.state.adapter_tree()
			-- 					end)
			-- 					if not ok then
			-- 						-- Fallback: try to run discovery directly
			-- 						pcall(function()
			-- 							neotest.run.run({ current_file, discovery = true })
			-- 						end)
			-- 					end
			-- 				end
			-- 			end
			-- 		end, 1000)  -- Increased delay for rust-analyzer to fully initialize
			-- 	end,
			-- 	desc = "Refresh neotest discovery for Rust files",
			-- })

			vim.keymap.set("n", "<leader>tc", function()
				neotest.run.run()
			end)
			vim.keymap.set("n", "<leader>tf", function()
				neotest.run.run(vim.fn.expand("%"))
			end)
		end,
	},
}
