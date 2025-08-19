return {
  'neovim/nvim-lspconfig',
  event = { 'BufReadPre', 'BufNewFile' },
  config = function()
    -- Shared global config
    vim.lsp.config('*', {
      capabilities = vim.lsp.protocol.make_client_capabilities(),
      root_markers = { '.git' },
    })

    -- clangd with diagnostics and root detection
    vim.lsp.config('clangd', {
      cmd = { 'clangd' },
      filetypes = { 'c', 'cpp' },
      root_markers = { '.clangd', 'compile_commands.json', '.git' },
    })

    -- Lua LSP
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

    vim.lsp.config('pyright', {
      cmd = { 'pyright-langserver', '--stdio' },
      filetypes = { 'python' },
    })

    vim.lsp.config('texlab', {
      cmd = { 'texlab' },
      filetypes = { 'tex', 'bib' },
    })

    vim.lsp.config('marksman', {
      cmd = { 'marksman' },
      filetypes = { 'markdown' },
    })

    vim.lsp.config('rust_hdl', {
      cmd = { 'vhdl_ls.cmd' }, -- correct executable name on Windows
      filetypes = { 'vhdl' },
      root_markers = { '.git' },
    })

    -- Enable each config
    for _, server in ipairs {
      'clangd',
      'lua_ls',
      'pyright',
      'texlab',
      'marksman',
      'rust_hdl',
    } do
      vim.lsp.enable(server)
    end

    -- Custom diagnostic display: show RIGHT not squiggles
    vim.diagnostic.config {
      virtual_text = {
        prefix = '', -- no squiggle prefix
        spacing = 4,
      },
      signs = false,
      underline = false,
      severity_sort = true,
      float = { border = 'rounded' },
    }

    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('my.lsp.attach', { clear = true }),
      callback = function(args)
        local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
        local bufnr = args.buf
      end,
    })
  end,
}
