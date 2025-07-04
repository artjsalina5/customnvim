return {
  {
    'lervag/vimtex',
    lazy = false,
    ft = { 'tex', 'bib', 'latex' },
    config = function()
      vim.opt.conceallevel = 2
      vim.g.vimtex_format_enabled = 1
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
