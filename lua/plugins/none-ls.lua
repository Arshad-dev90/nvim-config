return {
	"nvimtools/none-ls.nvim",
	dependencies = {
		"nvimtools/none-ls-extras.nvim",
		"jayp0521/mason-null-ls.nvim",
	},
	config = function()
		local null_ls = require("null-ls")
		local formatting = null_ls.builtins.formatting
		local diagnostics = null_ls.builtins.diagnostics

		require("mason-null-ls").setup({
			ensure_installed = {
				"prettier",
				"eslint_d",
				"shfmt",
				"checkmake",
				"clang_format",
			},
			automatic_installation = true,
		})

		local sources = {
			diagnostics.checkmake,
			formatting.prettier.with({
				filetypes = {
					"html",
					"json",
					"yaml",
					"markdown",
					"typescript",
					"typescriptreact",
					"javascript",
					"javascriptreact",
				},
			}),
			formatting.stylua,
			formatting.shfmt.with({ args = { "-i", "4" } }),
			formatting.terraform_fmt,
			formatting.clang_format,
			require("none-ls.formatting.ruff").with({ extra_args = { "--extend-select", "I" } }),
			require("none-ls.formatting.ruff_format"),
		}
		vim.keymap.set("n", "<C-s>", function()
			vim.lsp.buf.format({ async = false })
			vim.cmd("w")
		end, { desc = "Format and Save" })

		vim.keymap.set("i", "<C-s>", function()
			vim.lsp.buf.format({ async = false })
			vim.cmd("w")
		end, { desc = "Format and Save (insert mode)" })

		local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
		null_ls.setup({
			sources = sources,
			on_attach = function(client, bufnr)
				if client:supports_method("textDocument/formatting") then
					vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
					vim.api.nvim_create_autocmd("BufWritePre", {
						group = augroup,
						buffer = bufnr,
						callback = function()
							vim.lsp.buf.format({ async = false })
						end,
					})
				end
			end,
		})
	end,
}
