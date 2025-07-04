-- Highlight on yank
vim.api.nvim_create_autocmd('TextYankPost', {
  group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
  desc = 'Highlight yanked text',
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Disable auto-commenting on newline
vim.api.nvim_create_autocmd('BufEnter', {
  desc = 'Disable auto comment on newline',
  group = vim.api.nvim_create_augroup('no-auto-comment', { clear = true }),
  callback = function()
    vim.opt.formatoptions:remove { 'c', 'r', 'o' }
  end,
})
