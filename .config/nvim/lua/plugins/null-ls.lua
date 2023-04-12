return {
  "jose-elias-alvarez/null-ls.nvim",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local nls = require("null-ls")
    nls.setup({
      sources = {
        nls.builtins.diagnostics.shellcheck.with({
          diagnostics_format = "[SC#{c}] #{m}"
        }),
        nls.builtins.diagnostics.vint,
        nls.builtins.formatting.prettier.with({
          prefer_local = "node_modules/.bin",
        }),
      }
    })
  end
}

