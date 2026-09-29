return {
	{ url = "https://github.com/FacileStudio/kori.nvim", config = function()
		require("kori").setup({
			follow = "open",
		})
	end },
}