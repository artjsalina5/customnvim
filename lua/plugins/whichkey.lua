return {
  'folke/which-key.nvim',
  event = 'VimEnter',

  opts = {
    icons = {
      mappings = vim.g.have_nerd_font,
      keys = vim.g.have_nerd_font and {
        breadcrumb = '»',
        separator = '➜',
        group = '+',
      } or {
        Up = '<Up> ',
        Down = '<Down> ',
        Left = '<Left> ',
        Right = '<Right> ',
        C = '<C-…> ',
        M = '<M-…> ',
        D = '<D-…> ',
        S = '<S-…> ',
        CR = '<CR> ',
        Esc = '<Esc> ',
        ScrollWheelDown = '<ScrollWheelDown> ',
        ScrollWheelUp = '<ScrollWheelUp> ',
        NL = '<NL> ',
        BS = '<BS> ',
        Space = '<Space> ',
        Tab = '<Tab> ',
        F1 = '<F1>',
        F2 = '<F2>',
        F3 = '<F3>',
        F4 = '<F4>',
        F5 = '<F5>',
        F6 = '<F6>',
        F7 = '<F7>',
        F8 = '<F8>',
        F9 = '<F9>',
        F10 = '<F10>',
        F11 = '<F11>',
        F12 = '<F12>',
      },
    },

    spec = {
      -- Keybinding groups
      { '<leader>c', group = '[C]ode/LSP' },
      { '<leader>d', group = '[D]ocument' },
      { '<leader>r', group = '[R]ename' },
      { '<leader>s', group = '[S]earch' },
      { '<leader>w', group = '[W]orkspace' },
      { '<leader>t', group = '[T]oggle' },

      -- LSP commands with encoding-aware wrappers
      {
        '<leader>cD',
        function()
          vim.lsp.buf.declaration { position_encoding = get_lsp_encoding() }
        end,
        desc = '[D]eclaration',
      },
      {
        '<leader>cI',
        function()
          vim.lsp.buf.incoming_calls { position_encoding = get_lsp_encoding() }
        end,
        desc = '[I]ncoming Calls',
      },
      {
        '<leader>cO',
        function()
          vim.lsp.buf.outgoing_calls { position_encoding = get_lsp_encoding() }
        end,
        desc = '[O]utgoing Calls',
      },
      {
        '<leader>cS',
        require('telescope.builtin').lsp_document_symbols,
        desc = '[S]ymbols (Document)',
      },
      {
        '<leader>cW',
        require('telescope.builtin').lsp_dynamic_workspace_symbols,
        desc = '[W]orkspace Symbols (Telescope)',
      },
      {
        '<leader>ca',
        function()
          vim.lsp.buf.code_action { position_encoding = get_lsp_encoding() }
        end,
        desc = 'Code [A]ction',
      },
      {
        '<leader>cd',
        function()
          vim.lsp.buf.definition { position_encoding = get_lsp_encoding() }
        end,
        desc = '[D]efinition',
      },
      {
        '<leader>cf',
        function()
          vim.lsp.buf.format { async = true }
        end,
        desc = '[F]ormat Document',
      },
      {
        '<leader>ch',
        function()
          vim.lsp.buf.hover()
        end,
        desc = '[H]over Documentation',
      },
      {
        '<leader>ci',
        function()
          vim.lsp.buf.implementation { position_encoding = get_lsp_encoding() }
        end,
        desc = '[I]mplementation',
      },
      {
        '<leader>cn',
        function()
          vim.lsp.buf.rename { position_encoding = get_lsp_encoding() }
        end,
        desc = 'Re[n]ame Symbol',
      },
      {
        '<leader>cr',
        function()
          vim.lsp.buf.references { position_encoding = get_lsp_encoding() }
        end,
        desc = '[R]eferences',
      },
      {
        '<leader>cs',
        function()
          vim.lsp.buf.signature_help { position_encoding = get_lsp_encoding() }
        end,
        desc = '[S]ignature Help',
      },
      {
        '<leader>ct',
        function()
          vim.lsp.buf.type_definition { position_encoding = get_lsp_encoding() }
        end,
        desc = '[T]ype Definition',
      },
      {
        '<leader>cw',
        function()
          vim.lsp.buf.workspace_symbol { position_encoding = get_lsp_encoding() }
        end,
        desc = '[W]orkspace Symbol',
      },
    },
  },

  config = function(_, opts)
    -- Helper: Get encoding from first LSP client
    _G.get_lsp_encoding = function()
      for _, client in ipairs(vim.lsp.get_active_clients { bufnr = 0 }) do
        if client.offset_encoding then
          return client.offset_encoding
        end
      end
      return 'utf-8' -- fallback
    end

    require('which-key').setup(opts)
  end,
}
