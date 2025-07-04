return {
  {
    'MeanderingProgrammer/render-markdown.nvim',
    opts = {
      file_types = { 'markdown', 'norg', 'rmd', 'org' },
      code = {
        sign = false,
        width = 'block',
        right_pad = 1,
      },
      heading = {
        sign = false,
        icons = {},
      },
    },
    ft = { 'markdown', 'norg', 'rmd', 'org' }, -- Load the plugin only for specified file types
    config = function(_, opts)
      -- Setting up the plugin with the provided options
      require('render-markdown').setup(opts)

      -- Keybinding to toggle render-markdown functionality
      vim.api.nvim_set_keymap('n', '<leader>um', [[:lua require('render-markdown').toggle()<CR>]], { noremap = true, silent = true })

      -- Optionally, you can add a command as well for manual toggling
      vim.api.nvim_create_user_command('ToggleMarkdownRender', function()
        require('render-markdown').toggle()
      end, { desc = 'Toggle Markdown Render' })
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
