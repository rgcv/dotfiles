local function format()
  return vim.lsp.buf.format {
    async = true,
    filter = function (client)
      return client.name ~= "null-ls"
    end
  }
end

local function on_attach(_, bufnr)
  vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"

  local opts = { silent = true, buffer = bufnr }
  local map = function(mode, act, cmd)
    return vim.keymap.set(mode, act, cmd, opts)
  end
  map("n", "ga", "<Cmd>lua vim.lsp.buf.code_action()<CR>")
  map("n", "gD", "<Cmd>lua vim.lsp.buf.declaration()<CR>")
  map("n", "gd", "<Cmd>lua vim.lsp.buf.definition()<CR>")
  map("n", "K", "<Cmd>lua vim.lsp.buf.hover()<CR>")
  map("n", "gi", "<Cmd>lua vim.lsp.buf.implementation()<CR>")
  map("n", "<C-k>", "<Cmd>lua vim.lsp.buf.signature_help()<CR>")
  map("n", "<Leader>rn", "<Cmd>lua vim.lsp.buf.rename()<CR>")
  map("n", "gr", "<Cmd>lua vim.lsp.buf.references()<CR>")
  map("n", "[d", "<Cmd>lua vim.diagnostic.goto_prev()<CR>")
  map("n", "]d", "<Cmd>lua vim.diagnostic.goto_next()<CR>")
  map("n", "<Leader>f", format)
  map("v", "<Leader>f", function ()
    local result = format()
    vim.api.nvim_input("<Esc>")
    return result
  end)
end

local configs = {
  lua_ls = {
    settings = {
      Lua = {
        diagnostics = {
          globals = { "vim" }
        }
      }
    }
  },
  tsserver = {
    on_attach = function(client, bufnr)
      client.server_capabilities.document_formatting = false
      client.server_capabilities.document_range_formatting = false
      return on_attach(client, bufnr)
    end
  },
}

return {
  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
    config = function()
      require("mason").setup()
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "mason.nvim", "neovim/nvim-lspconfig" },
    config = function()
      local mlsp = require("mason-lspconfig")
      mlsp.setup()

      for _, name in pairs(mlsp.get_installed_servers()) do
        require("lspconfig")[name].setup(
          vim.tbl_extend(
            "force",
            { on_attach = on_attach },
            configs[name] or {}
          )
        )
      end

      for type, icon in pairs({
        Error = " ",
        Warn = " ",
        Hint = " ",
        Info = " "
      }) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
      end
    end
  },
}
