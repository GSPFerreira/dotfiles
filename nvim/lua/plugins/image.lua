return {
	"3rd/image.nvim",
	ft = { "markdown", "norg" },
	opts = {
		backend = "kitty", -- or "ueberzug" for X11
		integrations = {
			markdown = {
				enabled = true,
				clear_in_insert_mode = false,
				download_remote_images = true,
				only_render_image_at_cursor = true, -- defaults to false
				only_render_image_at_cursor_mode = "popup", -- "popup" or "inline", defaults to "popup"
				filetypes = { "markdown", "vimwiki" },
			},
		},
		max_width = 100,
		max_height = 12,
		max_height_window_percentage = math.huge,
		max_width_window_percentage = math.huge,
		window_overlap_clear_enabled = false,
		window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },
	},
}
