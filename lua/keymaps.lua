-- Keymap Options
local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Insert mode escape
map('i', 'jk', '<Esc>', { desc = 'Exit insert mode' })
map('t', 'jk', [[<C-\><C-n>]], { desc = 'Exit terminal mode' })

-- Clear search highlight
map('n', '<Esc>', '<cmd>nohlsearch<CR>', { desc = 'Clear search highlight' })

-- Diagnostics quickfix
map('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Diagnostics quickfix list' })

-- Terminal toggles
local function open_terminal(split_cmd, resize_cmd)
  local cwd = vim.fn.expand '%:p:h'
  vim.cmd(split_cmd)
  vim.cmd 'terminal'
  if resize_cmd then
    vim.cmd(resize_cmd)
  end
  vim.cmd('lcd ' .. cwd)
end

map('n', '<leader>h', function()
  open_terminal('botright split', 'resize 10')
end, { desc = 'Open horizontal terminal' })

map('n', '<leader>v', function()
  open_terminal 'vsplit'
  vim.cmd 'wincmd ='
end, { desc = 'Open vertical terminal' })

-- Window navigation
map('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus left' })
map('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus right' })
map('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus down' })
map('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus up' })

-- vim: ts=2 sts=2 sw=2 et
