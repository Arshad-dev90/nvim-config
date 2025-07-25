return {
  'nvim-neo-tree/neo-tree.nvim',
  branch = 'v3.x',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons',
    'MunifTanjim/nui.nvim',
    --'3rd/image.nvim',
    {
      's1n7ax/nvim-window-picker',
      version = '2.*',
      config = function()
        require('window-picker').setup {
          filter_rules = {
            include_current_win = false,
            autoselect_one = true,
            bo = {
              filetype = { 'neo-tree', 'neo-tree-popup', 'notify' },
              buftype = { 'terminal', 'quickfix' },
            },
          },
        }
      end,
    },
  },
  config = function()
    require('neo-tree').setup {
      close_if_last_window = true,
      popup_border_style = 'rounded',
      enable_git_status = true,
      enable_diagnostics = true,
      open_files_do_not_replace_types = { 'terminal', 'trouble', 'qf' },
      sort_case_insensitive = false,
      default_component_configs = {
        indent = {
          indent_size = 2,
          padding = 1,
          with_markers = true,
          indent_marker = '│',
          last_indent_marker = '└',
          highlight = 'NeoTreeIndentMarker',
          with_expanders = nil,
          expander_collapsed = '',
          expander_expanded = '',
          expander_highlight = 'NeoTreeExpander',
        },
        icon = {
          folder_closed = '',
          folder_open = '',
          folder_empty = '󰜌',
          default = '*',
          highlight = 'NeoTreeFileIcon',
        },
        modified = {
          symbol = '[+]',
          highlight = 'NeoTreeModified',
        },
        name = {
          trailing_slash = false,
          use_git_status_colors = true,
          highlight = 'NeoTreeFileName',
        },
        git_status = {
            symbols = {
              added     = "A",
              modified  = "M",
              deleted   = "D",
              renamed   = "R",
              untracked = "U",
              ignored   = "I",
              unstaged  = "✗",
              staged    = "✓",
              conflict  = "!",
            },
        },
      },
      window = {
        position = 'left',
        width = 30,
        mappings = {
          ['<space>'] = 'none',
          ['<tab>'] = 'toggle_node',
          ['l'] = 'open',
          ['h'] = 'close_node',
          ['v'] = 'open_vsplit',
          ['s'] = 'open_split',
        },
      },
      filesystem = {
        filtered_items = {
          visible = true,
          hide_dotfiles = false,
          hide_gitignored = true,
          never_show = {
	    '.DS_Store',
            'thumbs.db',
            'node_modules',
            '_pycache_',
            '.virtual_documents',
            '.git',
            '.python-version',
            '.venv',
          },
        },
        follow_current_file = {
          enabled = true,
        },
        use_libuv_file_watcher = true,
      },
    }
    buffers = {
        follow_current_file = {
          enabled = true,
          leave_dirs_open = false, 
        },
        group_empty_dirs = true, 
        show_unloaded = true,
        window = {
          mappings = {
            ['bd'] = 'buffer_delete',
            ['<bs>'] = 'navigate_up',
            ['.'] = 'set_root',
            ['o'] = { 'show_help', nowait = false, config = { title = 'Order by', prefix_key = 'o' } },
            ['oc'] = { 'order_by_created', nowait = false },
            ['od'] = { 'order_by_diagnostics', nowait = false },
            ['om'] = { 'order_by_modified', nowait = false },
            ['on'] = { 'order_by_name', nowait = false },
            ['os'] = { 'order_by_size', nowait = false },
            ['ot'] = { 'order_by_type', nowait = false },
          },
        },
      },

      vim.cmd([[
          highlight NeoTreeNormalNC guibg=NONE
          highlight NeoTreeNormal guibg=NONE
      ]])



    vim.cmd [[nnoremap \ :Neotree reveal<cr>]]
    vim.keymap.set('n', '<leader>e', ':Neotree toggle position=left<CR>', { noremap = true, silent = true })
    vim.keymap.set('n', '<leader>ngs', ':Neotree float git_status<CR>', { noremap = true, silent = true })
  end,
}

