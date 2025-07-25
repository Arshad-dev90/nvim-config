return {
    "lewis6991/gitsigns.nvim",
    opts = {
        signs = {
            add = { text = "+", hl = "GitSignsAdd" },
            change = { text = "~", hl = "GitSignsChange" },
            delete = { text = "_", hl = "GitSignsDelete" },
            topdelete = { text = "‾", hl = "GitSignsDelete" },
            changedelete = { text = "~", hl = "GitSignsChange" },
        },
        signs_staged = {
            add = { text = "+", hl = "GitSignsAddPreview" },
            change = { text = "~", hl = "GitSignsChangePreview" },
            delete = { text = "_", hl = "GitSignsDeletePreview" },
            topdelete = { text = "‾", hl = "GitSignsDeletePreview" },
            changedelete = { text = "~", hl = "GitSignsChangePreview" },
        },
        on_attach = function()
            vim.cmd([[
        highlight GitSignsAdd          guifg=#9ece6a
        highlight GitSignsChange       guifg=#e0af68
        highlight GitSignsDelete       guifg=#f7768e
        highlight GitSignsAddPreview   guifg=#73daca
        highlight GitSignsChangePreview guifg=#ff9e64
        highlight GitSignsDeletePreview guifg=#f7768e
      ]])
        end,
    },
}
