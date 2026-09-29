return {
	{ url = "https://github.com/3rd/image.nvim", config = function()
		if vim.fn.executable("magick") == 0 and vim.fn.executable("convert") == 0 then
			return
		end

		local image_ok, image = pcall(require, "image")
		if not image_ok then
			return
		end

		image.setup({
			processor = "magick_cli",
			max_height_window_percentage = 50,
			tmux_show_only_in_active_window = true,
			hijack_file_patterns = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp", "*.avif" },
		})
	end },
}