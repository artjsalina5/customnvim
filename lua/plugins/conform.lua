return {
  'stevearc/conform.nvim',
  lazy = true,
  event = { 'BufWritePre' },
  cmd = { 'ConformInfo' },
  keys = {
    {
      '<leader>f',
      function()
        require('conform').format { async = true }
      end,
      desc = 'Format buffer',
    },
  },
  opts = {
    formatters_by_ft = {
      lua = { 'stylua' },
      python = function(bufnr)
        if require('conform').get_formatter_info('ruff_format', bufnr).available then
          return { 'ruff_format' }
        else
          return { 'isort', 'black' }
        end
      end,
      javascript = { 'prettierd' },
      c = { 'clang_format' },
      ['_'] = { 'trim_whitespace' },
    },
    format_on_save = {
      timeout_ms = 500,
      lsp_fallback = true,
    },
    default_format_opts = {
      lsp_fallback = true,
    },
    log_level = vim.log.levels.ERROR,
    notify_on_error = true,
    notify_no_formatters = true,
  },
}
-- vim: ts=2 sts=2 sw=2 et
