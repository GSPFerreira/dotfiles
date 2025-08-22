return {
	"sainnhe/gruvbox-material",
	priority = 1000,
	config = function()
		vim.opt.termguicolors = true
		vim.g.gruvbox_material_transparent_background = 1
		vim.g.gruvbox_material_background = "hard"
		vim.g.gruvbox_material_better_performance = 1
		vim.g.gruvbox_material_enable_italic = true
		-- highlight line with error
		vim.g.gruvbox_material_diagnostic_text_highlight = 1
		-- highlight error message
		vim.g.gruvbox_material_diagnostic_virtual_text = "highlighted"
		vim.cmd.colorscheme("gruvbox-material")
	end,
}
