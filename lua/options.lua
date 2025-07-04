-- Clipboard: Enable access to system clipboard (macOS/Linux/WSL/Windows with unnamedplus)
vim.schedule(function()
  vim.opt.clipboard = 'unnamedplus'
end)

-- Appearance and UI
vim.opt.termguicolors = true
vim.opt.guicursor = 'a:block-blinkon0'
vim.opt.colorcolumn = '80'
vim.opt.cursorline = true
vim.opt.cursorcolumn = true
vim.opt.ruler = true
vim.opt.signcolumn = 'yes'
vim.opt.laststatus = 2
vim.opt.showmode = false
vim.opt.list = true
vim.opt.listchars = {
  tab = '» ',
  trail = '·',
  nbsp = '␣',
}

-- Line numbers
vim.opt.relativenumber = true
vim.opt.modeline = true

-- Searching
vim.opt.ignorecase = true
vim.opt.incsearch = true
vim.opt.hlsearch = true
vim.opt.inccommand = 'split'

-- Scrolling and screen behavior
vim.opt.scrolloff = 10
vim.opt.lazyredraw = true

-- Splits
vim.opt.splitright = true
vim.opt.splitbelow = true

-- File handling
vim.opt.hidden = true
vim.opt.autochdir = true
vim.opt.undofile = true
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300

-- Tabs and indentation
vim.opt.expandtab = false
vim.opt.tabstop = 8
vim.opt.shiftwidth = 8
vim.opt.smartindent = true
vim.opt.softtabstop = 0
vim.opt.breakindent = true

-- Input
vim.opt.mouse = ''

-- Suppress deprecated warning from older plugins (optional)
vim.deprecate = function() end

-- Platform-specific shell setup
if vim.fn.has 'win32' == 1 then
  vim.opt.shell = 'pwsh'
  vim.opt.shellcmdflag = '-NoLogo -NoProfile -Command "&"'
  vim.opt.shellredir = '2>&1'
  vim.opt.shellpipe = '2>&1'
  vim.opt.shellquote = ''
  vim.opt.shellxquote = ''
end

-- Set manual page viewer depending on platform
vim.g.manpager = vim.fn.has 'win32' == 1 and 'wsl man' or 'man'
