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
					require("rustaceanvim.neotest"),
				},
			})

			vim.keymap.set("n", "<leader>tc", function()
				neotest.run.run()
			end)
		end,
	},
}
