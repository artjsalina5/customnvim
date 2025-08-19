return {
  'stevearc/conform.nvim',
  event = { 'BufWritePre' },
  cmd = { 'ConformInfo' },
  keys = {
    {
      '<leader>f',
      function()
        require('conform').format { async = true }
      end,
      mode = { 'n', 'v' },
      desc = 'Format buffer/range',
    },
  },
  ---@type conform.setupOpts
  opts = {
    formatters_by_ft = {
      lua = { 'stylua' },
      python = { 'isort', 'black' },
      javascript = { 'prettierd', 'prettier', stop_after_first = true },
      vhdl = { 'vsg' },
    },
    default_format_opts = {
      lsp_format = 'fallback',
      timeout_ms = 5000, -- ↑ give VSG time to run
    },
    format_on_save = { timeout_ms = 5000 },
    formatters = {
      vsg = {
        inherit = false,
        command = 'vsg', -- Mason shim resolves to vsg.CMD on Windows
        stdin = false, -- required for in-place fix
        exit_codes = { 0, 1 },
        args = function(_, ctx)
          -- Directly fix the file shown in the buffer
          local cfg = vim.fs.find({
            'vsg_rules.json',
            'vsg.json',
            '.vsg.json',
            'sep_cci_vsg.json',
          }, {
            path = ctx.filename and vim.fs.dirname(ctx.filename) or vim.uv.cwd(),
            upward = true,
          })[1]

          if cfg then
            return { '-f', ctx.filename, '--fix', '-c', cfg }
          else
            return { '-f', ctx.filename, '--fix', '--style', 'indent_only' }
          end
        end,
        condition = function(_, ctx)
          return ctx.filename ~= nil and ctx.filename ~= '' and ctx.filename:lower():match '%.vhd$'
        end,
      },
      shfmt = { prepend_args = { '-i', '2' } },
    },
  },
  init = function()
    vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
  end,
}
