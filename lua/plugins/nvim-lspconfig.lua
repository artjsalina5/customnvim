return {
  {
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      },
    },
  },
  {
    'neovim/nvim-lspconfig',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
      {
        'mason-org/mason.nvim',
        cmd = { 'Mason', 'MasonInstall', 'MasonUpdate' },
        opts = {
          ui = {
            border = 'rounded',
            icons = {
              package_installed = '✓',
              package_pending = '➜',
              package_uninstalled = '✗',
            },
          },
        },
      },
      'williamboman/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      { 'j-hui/fidget.nvim', opts = {} },
      'saghen/blink.cmp',
      {
        'nvimtools/none-ls.nvim',
        dependencies = { 'mason-org/mason.nvim', 'nvimtools/none-ls-extras.nvim' },
      },
      {
        'p00f/clangd_extensions.nvim',
        ft = { 'c', 'cpp', 'objc', 'objcpp' },
      },
    },
    config = function()
      local lspconfig = require 'lspconfig'
      local mason_lspconfig = require 'mason-lspconfig'

      -- Create a fresh copy of capabilities to avoid modifying shared references
      local capabilities = vim.tbl_deep_extend('force', {}, require('blink.cmp').get_lsp_capabilities())

      -- LSP Attach keymaps
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
        callback = function(event)
          local bufnr = event.buf
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          local encoding = client and client.offset_encoding or 'utf-8'

          local function map(keys, func, desc, mode)
            vim.keymap.set(mode or 'n', keys, func, { buffer = bufnr, desc = 'LSP: ' .. desc })
          end

          map('grn', function()
            vim.lsp.buf.rename { position_encoding = encoding }
          end, '[R]e[n]ame')

          map('gra', function()
            vim.lsp.buf.code_action { position_encoding = encoding }
          end, '[G]oto Code [A]ction', { 'n', 'x' })

          map('grr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
          map('gri', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
          map('grd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
          map('grD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
          map('gO', require('telescope.builtin').lsp_document_symbols, 'Open Document Symbols')
          map('gW', require('telescope.builtin').lsp_dynamic_workspace_symbols, 'Open Workspace Symbols')
          map('grt', require('telescope.builtin').lsp_type_definitions, '[G]oto [T]ype Definition')

          if client and client.supports_method 'textDocument/documentHighlight' then
            local hl_group = vim.api.nvim_create_augroup('lsp-highlight', { clear = false })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              group = hl_group,
              buffer = bufnr,
              callback = vim.lsp.buf.document_highlight,
            })
            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              group = hl_group,
              buffer = bufnr,
              callback = vim.lsp.buf.clear_references,
            })
          end

          if client and client.supports_method 'textDocument/inlayHint' then
            map('<leader>th', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = bufnr })
            end, '[T]oggle Inlay [H]ints')
          end
        end,
      })

      vim.diagnostic.config {
        virtual_text = { prefix = '●', spacing = 2 },
        signs = vim.g.have_nerd_font and {
          text = {
            [vim.diagnostic.severity.ERROR] = '󰅚 ',
            [vim.diagnostic.severity.WARN] = '󰀪 ',
            [vim.diagnostic.severity.INFO] = '󰋽 ',
            [vim.diagnostic.severity.HINT] = '󰌶 ',
          },
        } or {},
        underline = true,
        float = { source = 'if_many', border = 'rounded' },
        severity_sort = true,
      }

      local servers = {
        lua_ls = {
          settings = {
            Lua = {
              completion = { callSnippet = 'Replace' },
              diagnostics = { globals = { 'vim' } },
              workspace = {
                library = vim.api.nvim_get_runtime_file('', true),
                checkThirdParty = false,
              },
              telemetry = { enable = false },
            },
          },
        },
        clangd = {}, -- handled separately
        marksman = {},
        texlab = {},
      }

      local ensure_lsp = vim.tbl_keys(servers)
      local ensure_tools = {
        'stylua',
        'clang-format',
        'black',
        'isort',
        'prettier',
        'prettierd',
        'bibtex-tidy',
        'markdownlint',
        'flake8',
        'eslint_d',
      }

      mason_lspconfig.setup {
        ensure_installed = ensure_lsp,
        handlers = {
          function(server)
            if server == 'clangd' then
              return
            end
            local opts = servers[server] or {}
            opts.capabilities = vim.tbl_deep_extend('force', {}, capabilities, opts.capabilities or {})
            lspconfig[server].setup(opts)
          end,
        },
      }

      require('mason-tool-installer').setup {
        ensure_installed = vim.list_extend(vim.tbl_deep_extend('force', {}, ensure_lsp), ensure_tools),
      }

      require('clangd_extensions').setup {
        server = {
          cmd = {
            'clangd',
            '--fallback-style=none', -- So only .clang-format is used
            '--clang-tidy',
            '--enable-config',
          },
          capabilities = vim.tbl_deep_extend('force', {}, capabilities, {
            offsetEncoding = { 'utf-8' },
          }),
          root_dir = function(fname)
            local util = require 'lspconfig.util'
            return util.root_pattern('.clang-format', '.git')(fname) or vim.fn.expand '$HOME/.config/nvim'
          end,
        },
      }

      local null_ls = require 'null-ls'

      null_ls.setup {
        sources = vim.tbl_filter(function(x)
          return x ~= nil
        end, {
          null_ls.builtins.completion.spell,
          require 'none-ls.formatting.jq',
          require 'none-ls.diagnostics.eslint',
        }),
        on_attach = function(client, _)
          client.server_capabilities.documentFormattingProvider = false
          client.server_capabilities.documentRangeFormattingProvider = false
        end,
      }
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
