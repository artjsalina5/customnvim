vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.opt.shortmess:append 'I'
vim.g.have_nerd_font = true

-- Vim option import
require 'options'

-- Remaps
require 'keymaps'

-- Autocommands
require 'autocmds'

-- plugin manager installer
require 'lazy-bootstrap'

-- Plugin Setup and linking
require 'lazy-plugins'

-- Health Checks
require 'health'

-- vim: ts=2 sts=2 sw=2 et
