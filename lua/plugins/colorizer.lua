return {
	"NvChad/nvim-colorizer.lua",
	event = { "BufReadPre", "BufNewFile" },
	opts = {
		filetypes = {
			"css",
			"scss",
			"html",
			"javascript",
			"javascriptreact",
			"typescript",
			"typescriptreact",
			"vue",
			"svelte",
			"astro",
		},
		user_default_options = {
			tailwind = true,
			names = false,
			mode = "background",
		},
	},
}
