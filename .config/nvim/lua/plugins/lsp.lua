return {
  {
    "VonHeikemen/lsp-zero.nvim",
    branch = "v2.x",
    lazy = true,
    config = function()
      require("lsp-zero.settings").preset({})
    end
  },

  -- Autocompletion
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      { "L3MON4D3/LuaSnip" },
    },
    config = function()
      require("lsp-zero.cmp").extend()
    end
  },

  -- LSP
  {
    "neovim/nvim-lspconfig",
    cmd = "LspInfo",
    event = {"BufReadPre", "BufNewFile"},
    dependencies = {
      { "hrsh7th/cmp-nvim-lsp" },
      { "williamboman/mason-lspconfig.nvim" },
      {
        "williamboman/mason.nvim",
        build = function()
          pcall(vim.cmd, "MasonUpdate")
        end,
      },
      {
        "jose-elias-alvarez/null-ls.nvim",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = { "nvim-lua/plenary.nvim" },
      }
    },
    config = function()
      local lsp = require("lsp-zero")
      lsp.on_attach(function(_, bufnr)
        vim.keymap.set("n", "ga", vim.lsp.buf.code_action)
        vim.keymap.set("n", "<Leader>rn", vim.lsp.buf.rename)
        vim.keymap.set("n", "<Leader>f", vim.lsp.buf.format)
        vim.keymap.set("v", "<Leader>f", vim.lsp.buf.format)
        lsp.default_keymaps({ buffer = bufnr })
      end)

      require("lspconfig").lua_ls.setup(lsp.nvim_lua_ls())

      lsp.setup()

      local nls = require("null-ls")
      nls.setup({
        sources = {
          nls.builtins.diagnostics.shellcheck.with({
            diagnostics_format = "[SC#{c}] #{m}",
          }),
          nls.builtins.diagnostics.vint,
          nls.builtins.formatting.prettier.with({
            prefer_local = "node_modules/.bin"
          }),
        }
      })
    end,
  }
}
