return {
  'neovim/nvim-lspconfig',
  event = { 'BufReadPre', 'BufNewFile' },
  config = function()
    vim.lsp.enable 'clangd'
    vim.lsp.enable 'pyright'
    vim.lsp.enable 'lua_ls'
    vim.lsp.enable 'texlab'
    vim.lsp.enable 'marksman'

  end,
}
-- vim: ts=2 sts=2 sw=2 et
