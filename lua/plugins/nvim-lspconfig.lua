return {
  'neovim/nvim-lspconfig',
  event = { 'BufReadPre', 'BufNewFile' },
  config = function()
    vim.lsp.enable 'clangd'
    vim.lsp.enable 'pyright'
    vim.lsp.enable 'lua_ls'
    vim.lsp.enable 'texlab'
    vim.lsp.enable 'marksman'

    vim.lsp.config('clangd', {
      cmd = { 'clangd', '--background-index', '--header-insertion=iwyu' },
    })

    vim.lsp.config('lua_ls', {
      settings = {
        Lua = {
          diagnostics = { globals = { 'vim' } },
          workspace = { checkThirdParty = false },
        },
      },
    })
  end,
}
-- vim: ts=2 sts=2 sw=2 et
