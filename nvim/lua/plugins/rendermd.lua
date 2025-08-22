return {
	-- Make sure to set this up properly if you have lazy=true
	"MeanderingProgrammer/render-markdown.nvim",
	dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.nvim" },
	ft = { "markdown" },
	config = true,
	opts = {
		-- see below for full list of options 👇
		render_modes = true, -- Render in ALL modes
		sign = {
			enabled = true, -- Turn on in the status column
		},
	},
}
