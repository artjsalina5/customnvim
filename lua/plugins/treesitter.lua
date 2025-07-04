return {
  'nvim-treesitter/nvim-treesitter',
  build = ':TSUpdate',
  opts = {
    ensure_installed = {
      'bash',
      'c',
      'diff',
      'html',
      'lua',
      'luadoc',
      'markdown',
      'markdown_inline',
      'ninja',
      'python',
      'query',
      'rst',
      'vim',
      'vimdoc',
      'vhdl',
    },
    auto_install = true,
    ignore_install = {},
    highlight = {
      enable = true,
      disable = { 'latex' },
      additional_vim_regex_highlighting = { 'ruby', 'python' },
    },
    indent = { enable = true },
  },
  config = function(_, opts)
    local ts = require 'nvim-treesitter.configs'
    ts.setup(opts)

    -- Associate custom file extensions with VHDL
    vim.filetype.add {
      extension = {
        dwv = 'vhdl',
        dwa = 'vhdl',
        tsv = 'vhdl',
      },
    }
  end,
}
-- vim: ts=2 sts=2 sw=2 et
