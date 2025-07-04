return {
  'github/copilot.vim',
  lazy = false,
  priority = 100,
  config = function()
    vim.g.copilot_disable = false

    -- Optional: Workspace folders to improve completion quality
    vim.g.copilot_workspace_folders = { '~/mnt/c/home/Projects' }
    vim.g.copilot_no_tab_map = true

    vim.keymap.set('i', '<C-J>', 'copilot#Accept("<CR>")', {
      expr = true,
      silent = true,
      replace_keycodes = false,
    })
  end,
}
-- vim: ts=2 sts=2 sw=2 et
