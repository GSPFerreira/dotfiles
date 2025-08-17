return {
	-- Make sure to set this up properly if you have lazy=true
	"MeanderingProgrammer/render-markdown.nvim",
	ft = { "markdown", "codecompanion", "Avante" },
	config = true,
	opts = {
		inline_code = { conceal = true },
		headings = { conceal = true },
		bullets = { conceal = true },
		-- see below for full list of options 👇
		render_modes = true, -- Render in ALL modes
		sign = {
			enabled = false, -- Turn off in the status column
		},
	},
}
