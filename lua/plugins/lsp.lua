return {
    "neovim/nvim-lspconfig",
    dependencies = {
        { "williamboman/mason.nvim", opts = {} },
        "williamboman/mason-lspconfig.nvim",
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        { "j-hui/fidget.nvim", opts = {} },
        "saghen/blink.cmp",
    },
    config = function()
        vim.api.nvim_create_autocmd("LspAttach", {
            group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
            callback = function(event)
                local map = function(keys, func, desc, mode)
                    mode = mode or "n"
                    vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
                end

                map("grn", vim.lsp.buf.rename, "[R]e[n]ame")
                map("gra", vim.lsp.buf.code_action, "[C]ode [A]ction", { "n", "x" })
                map("grr", require("telescope.builtin").lsp_references, "[R]eferences")
                map("gri", require("telescope.builtin").lsp_implementations, "[I]mplementation")
                map("grd", require("telescope.builtin").lsp_definitions, "[D]efinition")
                map("grD", vim.lsp.buf.declaration, "[D]eclaration")
                map("gO", require("telescope.builtin").lsp_document_symbols, "Doc Symbols")
                map("gW", require("telescope.builtin").lsp_dynamic_workspace_symbols, "Workspace Symbols")
                map("grt", require("telescope.builtin").lsp_type_definitions, "[T]ype Def")

                local client = vim.lsp.get_client_by_id(event.data.client_id)
                if client and client.supports_method("textDocument/documentHighlight") then
                    local highlight_augroup = vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })

                    vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
                        buffer = event.buf,
                        group = highlight_augroup,
                        callback = vim.lsp.buf.document_highlight,
                    })

                    vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
                        buffer = event.buf,
                        group = highlight_augroup,
                        callback = vim.lsp.buf.clear_references,
                    })

                    vim.api.nvim_create_autocmd("LspDetach", {
                        group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
                        callback = function(event2)
                            vim.lsp.buf.clear_references()
                            vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = event2.buf })
                        end,
                    })
                end

                if client and client.supports_method("textDocument/inlayHint") then
                    map("<leader>th", function()
                        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
                    end, "[T]oggle Inlay [H]ints")
                end
            end,
        })

        vim.diagnostic.config({
            severity_sort = true,
            float = { border = "rounded", source = "if_many" },
            underline = { severity = vim.diagnostic.severity.ERROR },
            signs = vim.g.have_nerd_font and {
                text = {
                    [vim.diagnostic.severity.ERROR] = "󰅚 ",
                    [vim.diagnostic.severity.WARN] = "󰀪 ",
                    [vim.diagnostic.severity.INFO] = "󰋽 ",
                    [vim.diagnostic.severity.HINT] = "󰌶 ",
                },
            } or {},
            virtual_text = {
                source = "if_many",
                spacing = 2,
                format = function(diagnostic)
                    return diagnostic.message
                end,
            },
        })

        local capabilities = require("blink.cmp").get_lsp_capabilities()

        local servers = {
            ts_ls = {
            cmd = { "typescript-language-server", "--stdio" },
            filetypes = {
              "javascript",
              "javascriptreact",
              "javascript.jsx",
              "typescript",
              "typescriptreact",
              "typescript.tsx",
            },
            init_options = {
              hostInfo = "neovim",
            },
            root_dir = require("lspconfig.util").root_pattern(
              "tsconfig.json",
              "jsconfig.json",
              "package.json",
              ".git"
            ),
          },
            emmet_ls = {
                filetypes = { "html", "css", "typescriptreact", "javascriptreact" },
            },
            ruff = {},
            pylsp = {
                settings = {
                    pylsp = {
                        plugins = {
                            pyflakes = { enabled = false },
                            pycodestyle = { enabled = false },
                            autopep8 = { enabled = false },
                            yapf = { enabled = false },
                            mccabe = { enabled = false },
                            pylsp_mypy = { enabled = false },
                            pylsp_black = { enabled = false },
                            pylsp_isort = { enabled = false },
                        },
                    },
                },
            },
            html = {
            filetypes = { "html" },
            cmd = { "vscode-html-language-server", "--stdio" },
            root_dir = require("lspconfig.util").root_pattern(".git", "index.html"),
          },
            cssls = {
            filetypes = { "css", "scss", "less" },
            cmd = { "vscode-css-language-server", "--stdio" },
            root_dir = require("lspconfig.util").root_pattern(".git", "package.json"),
          },

          tailwindcss = {
            filetypes = {
              "html",
              "javascript",
              "javascriptreact",
              "typescript",
              "typescriptreact",
              "vue",
              "svelte",
            },
            cmd = { "tailwindcss-language-server", "--stdio" },
            root_dir = require("lspconfig.util").root_pattern("tailwind.config.js", "tailwind.config.cjs", "tailwind.config.ts", "postcss.config.js", "package.json", ".git"),
            init_options = {
              userLanguages = {
                eelixir = "html",
                eruby = "html",
              },
            },
          },
            dockerls = {
            filetypes = { "dockerfile" },
            cmd = { "docker-langserver", "--stdio" },
            root_dir = require("lspconfig.util").root_pattern(".git", "Dockerfile"),
          },

            rust_analyzer = {},
            clangd = {},
            sqlls = {},
            terraformls = {},
            jsonls = {},
            yamlls = {},
              lua_ls = {
                filetypes = { "lua" },
                settings = {
                  Lua = {
                    runtime = {
                      version = "LuaJIT",
                      path = vim.split(package.path, ";"),
                    },
                    diagnostics = {
                      enable = true,
                      globals = { "vim" }, -- ✅ Tell the server "vim" is global
                    },
                    workspace = {
                      library = {
                        [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                        [vim.fn.stdpath("config") .. "/lua"] = true,
                      },
                      checkThirdParty = false,
                    },
                    telemetry = {
                      enable = false,
                    },
                  },
                },
              },
      }

        local ensure_installed = vim.tbl_keys(servers or {})
        vim.list_extend(ensure_installed, {
            "stylua",
            "emmet_ls",
            "typescript-language-server",
        })

        require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

        require("mason-lspconfig").setup({
            ensure_installed = {},
            automatic_installation = false,
            handlers = {
                function(server_name)
                    local server = servers[server_name] or {}
                    server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
                    require("lspconfig")[server_name].setup(server)
                end,
            },
        })
    end,
}

