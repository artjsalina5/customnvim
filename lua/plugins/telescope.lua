return {
  'nvim-telescope/telescope.nvim',
  event = 'VimEnter',
  branch = '0.1.x',
  dependencies = {
    'nvim-lua/plenary.nvim',
    {
      'nvim-telescope/telescope-fzf-native.nvim',
      build = 'make',
      cond = function()
        return vim.fn.executable 'make' == 1
      end,
    },
    'nvim-telescope/telescope-ui-select.nvim',
    { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
  },
  config = function()
    local telescope = require 'telescope'
    local builtin = require 'telescope.builtin'
    local dropdown = require('telescope.themes').get_dropdown
    local stdpath = vim.fn.stdpath

    telescope.setup {
      defaults = {
        mappings = {
          i = {
            ['<C-Enter>'] = 'to_fuzzy_refine',
          },
        },
      },
      extensions = {
        ['ui-select'] = dropdown(),
      },
    }

    for _, ext in ipairs { 'fzf', 'ui-select' } do
      pcall(telescope.load_extension, ext)
    end

    local map = vim.keymap.set
    local opts = { noremap = true, silent = true }

    -- LSP-related pickers
    map('n', '<leader>ssy', builtin.lsp_dynamic_workspace_symbols, { desc = '[S]earch [Sy]mbols in Workspace' })
    map('n', '<leader>ssd', builtin.lsp_document_symbols, { desc = '[S]earch [S]ymbols in current [D]ocument' })
    map('n', '<leader>sgr', builtin.lsp_references, { desc = '[S]earch [G]oto [R]eferences' })
    map('n', '<leader>sgd', builtin.lsp_definitions, { desc = '[S]earch [G]oto [D]efinition' })
    map('n', '<leader>sgi', builtin.lsp_implementations, { desc = '[S]earch [G]oto [I]mplementations' })
    map('n', '<leader>sgt', builtin.lsp_type_definitions, { desc = '[S]earch [G]oto [T]ype Definition' })
    map('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
    map('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
    map('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
    map('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
    map('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
    map('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
    map('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
    map('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
    map('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
    map('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })

    map('n', '<leader>/', function()
      builtin.current_buffer_fuzzy_find(dropdown {
        winblend = 10,
        previewer = false,
      })
    end, { desc = '[/] Fuzzily search in current buffer' })

    map('n', '<leader>s/', function()
      builtin.live_grep {
        grep_open_files = true,
        prompt_title = 'Live Grep in Open Files',
      }
    end, { desc = '[S]earch [/] in Open Files' })

    map('n', '<leader>sn', function()
      builtin.find_files { cwd = stdpath 'config' }
    end, { desc = '[S]earch [N]eovim files' })
  end,
}
-- vim: ts=2 sts=2 sw=2 et
