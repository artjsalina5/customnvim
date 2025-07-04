return {
  'github/copilot.vim',
  lazy = true,
  priority = 100,
  config = function()
    vim.g.copilot_disable = true
  end,
}
-- vim: ts=2 sts=2 sw=2 et
