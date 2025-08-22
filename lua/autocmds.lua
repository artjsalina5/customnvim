-- Highlight on yank
vim.api.nvim_create_autocmd('TextYankPost', {
  group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
  desc = 'Highlight yanked text',
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Disable auto-commenting on newline
--vim.api.nvim_create_autocmd('BufEnter', {
--  desc = 'Disable auto comment on newline',
--  group = vim.api.nvim_create_augroup('no-auto-comment', { clear = true }),
--  callback = function()
--    vim.opt.formatoptions:remove { 'c', 'r', 'o' }
--  end,
--})

-- Autocmd for LSP attach
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('my.lsp', {}),
  callback = function(args)
    local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
    if client:supports_method 'textDocument/implementation' then
      -- Create a keymap for vim.lsp.buf.implementation ...
      vim.keymap.set('n', '<leader>gi', vim.lsp.buf.implementation, { desc = 'LSP Jump to Implementation' })
      vim.keymap.set('n', '<leader>gd', vim.lsp.buf.definition, { desc = 'LSP Jump to Definition' })
      vim.keymap.set('n', '<leader>gs', vim.lsp.buf.signature_help, { desc = 'LSP Signature Help' })
    end
    -- Enable auto-completion. Note: Use CTRL-Y to select an item. |complete_CTRL-Y|
    -- Auto-format ("lint") on save.
    -- Usually not needed if server supports "textDocument/willSaveWaitUntil".
    if not client:supports_method 'textDocument/willSaveWaitUntil' and client:supports_method 'textDocument/formatting' then
      vim.api.nvim_create_autocmd('BufWritePre', {
        group = vim.api.nvim_create_augroup('my.lsp', { clear = false }),
        buffer = args.buf,
        callback = function()
          vim.lsp.buf.format { bufnr = args.buf, id = client.id, timeout_ms = 1000 }
        end,
      })
    end
  end,
})
