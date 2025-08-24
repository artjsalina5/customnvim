return {
  {
    "mrcjkb/haskell-tools.nvim",
    version = "^3",
    ft = { "haskell", "lhaskell", "cabal", "cabalproject" },
    dependencies = {
      { "nvim-telescope/telescope.nvim", optional = true },
    },
    config = function()
      local ok, telescope = pcall(require, "telescope")
      if ok then
        telescope.load_extension("ht")
      end

      local ht = require('haskell-tools')
      local bufnr = vim.api.nvim_get_current_buf()
      local opts = { noremap = true, silent = true, buffer = bufnr }
      vim.keymap.set('n', '<space>gcl', vim.lsp.codelens.run, { desc = '{opts} Run Codelens' })
      -- Hoogle search for the type signature of the definition under the cursor
      vim.keymap.set('n', '<space>ghs', ht.hoogle.hoogle_signature, { desc = 'View Hoogle Singature' })
      -- Evaluate all code snippets
      vim.keymap.set('n', '<space>gea', ht.lsp.buf_eval_all, { desc = 'Evaluate all code snippets' })
      -- Toggle a GHCi repl for the current package
      vim.keymap.set('n', '<leader>grr', ht.repl.toggle, { desc = 'Toggle a GHCi repl for the current package' })
      -- Toggle a GHCi repl for the current buffer
      vim.keymap.set('n', '<leader>grf', function()
        ht.repl.toggle(vim.api.nvim_buf_get_name(0))
      end, { desc = 'Toggle a GHCi repl for the current buffer' })
      vim.keymap.set('n', '<leader>grq', ht.repl.quit, { desc = 'End GHCi repl' })
    end,
  },
  {
    "mrcjkb/haskell-snippets.nvim",
    dependencies = { "L3MON4D3/LuaSnip" },
    ft = { "haskell", "lhaskell", "cabal", "cabalproject" },
    config = function()
      local haskell_snippets = require("haskell-snippets").all
      require("luasnip").add_snippets("haskell", haskell_snippets, { key = "haskell" })
    end,
  },
  {
    "luc-tielen/telescope_hoogle",
    ft = { "haskell", "lhaskell", "cabal", "cabalproject" },
    dependencies = {
      { "nvim-telescope/telescope.nvim" },
    },
    config = function()
      local ok, telescope = pcall(require, "telescope")
      if ok then
        telescope.load_extension("hoogle")
      end
    end,
  },
}
