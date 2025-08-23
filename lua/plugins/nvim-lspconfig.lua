return {
  {
    'mason-org/mason-lspconfig.nvim',
    dependencies = {
      { 'mason-org/mason.nvim', opts = {} },
      'neovim/nvim-lspconfig',
    },
    opts = {
      ---@type string[]
      ensure_installed = {
        'lua_ls',
        'rust_analyzer',
        'clangd',
        'pyright',
        'texlab',
        'marksman',
        'hls',
      },
      ---@type boolean | string[] | { exclude: string[] }
      automatic_enable = true,
    },
  },

  -- Mason tool installer (formatters, linters, extras)
  {
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    opts = {
      ---@type string[]j
      ensure_installed = {
        'vim-language-server',
        'clang-format',
        'vsg',
        'shfmt',
        'lua_ls',
        'prettierd',
        'isort',
        'black',
        'bibtex-tidy',
      },
      integrations = { ['mason-lspconfig'] = true },
    },
  },

  -- LSP setup
  {
    'neovim/nvim-lspconfig',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      -- Shared defaults
      vim.lsp.config('*', {
        capabilities = vim.lsp.protocol.make_client_capabilities(),
        root_markers = { '.git' },
      })

      -- clangd
      vim.lsp.config('clangd', {
        cmd = clangd_cmd,
        filetypes = { 'c', 'cpp' },
        root_markers = { '.clangd', 'compile_commands.json', '.git' },
        on_attach = function(client, bufnr)
          client.server_capabilities.documentFormattingProvider = false
          client.server_capabilities.documentRangeFormattingProvider = false
        end,
      })

      -- Lua LS
      vim.lsp.config('lua_ls', {
        cmd = { 'lua-language-server' },
        filetypes = { 'lua' },
        root_markers = { '.luarc.json', '.luarc.jsonc', '.git' },
        settings = {
          Lua = {
            runtime = { version = 'LuaJIT' },
            diagnostics = { globals = { 'vim' } },
            workspace = { checkThirdParty = false },
          },
        },
      })

      -- Python
      vim.lsp.config('pyright', {
        cmd = { 'pyright-langserver', '--stdio' },
        filetypes = { 'python' },
      })

      -- TeX
      vim.lsp.config('texlab', {
        cmd = { 'texlab' },
        filetypes = { 'tex', 'bib' },
      })

      -- Markdown
      vim.lsp.config('marksman', {
        cmd = { 'marksman' },
        filetypes = { 'markdown' },
      })

      -- Haskell
      -- vim.lsp.enable 'hls'

      -- VHDL (rust_hdl)
      vim.lsp.config('rust_hdl', {
        cmd = { 'vhdl_ls.cmd' }, -- Windows-friendly
        filetypes = { 'vhdl' },
        root_markers = { '.git' },
      })

      -- Diagnostics styling
      vim.diagnostic.config {
        virtual_text = {
          prefix = '', -- no squiggles
          spacing = 4,
        },
        signs = false,
        underline = false,
        severity_sort = true,
        float = { border = 'rounded' },
      }
    end,
  },

  -- Formatter integration (conform.nvim)
  {
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
      {
        '<leader>f',
        function()
          require('conform').format { async = true, lsp_fallback = false }
        end,
        desc = '[F]ormat buffer',
      },
    },
    opts = {
      notify_on_error = true,
      format_on_save = function(bufnr)
        local disable_filetypes = { c = true, cpp = true }
        return {
          timeout_ms = 500,
          lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
        }
      end,
      formatters_by_ft = {
        python = { 'isort', 'black' },
        javascript = { 'prettierd' },
        typescript = { 'prettierd' },
        json = { 'prettierd' },
        html = { 'prettierd' },
        css = { 'prettierd' },
        yaml = { 'prettierd' },
        bib = { 'bibtex-tidy' },
        c = { 'clang_format' },
        cpp = { 'clang_format' },
      },
      formatters = {
        clang_format = {
          prepend_args = function(_, ctx)
            local config_path = vim.fn.fnamemodify(vim.env.MYVIMRC, ':h') .. '/.clang-format'
            if vim.fn.filereadable(config_path) == 1 then
              return {
                '--style=file:' .. config_path,
                '--fallback-style=none',
                '--assume-filename=' .. ctx.filename,
              }
            else
              return {}
            end
          end,
        },
        markdown_toc = {
          condition = function(_, ctx)
            for _, line in ipairs(vim.api.nvim_buf_get_lines(ctx.buf, 0, -1, false)) do
              if line:find '<!%-%- toc %-%->' then
                return true
              end
            end
          end,
        },
        markdownlint_cli2 = {
          condition = function(_, ctx)
            local diag = vim.tbl_filter(function(d)
              return d.source == 'markdownlint'
            end, vim.diagnostic.get(ctx.buf))
            return #diag > 0
          end,
        },
        isort = {
          extra_args = function()
            return { '--line-ending', vim.bo.fileformat == 'dos' and 'CRLF' or 'LF' }
          end,
        },
      },
    },
  },
}
-- vim: ts=2 sts=2 sw=2 et
