local function format()
  return vim.lsp.buf.format {
    async = true,
    filter = function (client)
      return client.name ~= 'null-ls'
    end
  }
end

local on_attach = function(_, bufnr)
  vim.bo[bufnr].omnifunc = 'v:lua.vim.lsp.omnifunc'

  local opts = { silent = true, buffer = bufnr }
  local map = function(mode, act, cmd)
    return vim.keymap.set(mode, act, cmd, opts)
  end
  map('n', 'ga', '<Cmd>lua vim.lsp.buf.code_action()<CR>')
  map('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>')
  map('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>')
  map('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>')
  map('n', 'gi', '<Cmd>lua vim.lsp.buf.implementation()<CR>')
  map('n', '<C-k>', '<Cmd>lua vim.lsp.buf.signature_help()<CR>')
  map('n', '<Leader>rn', '<Cmd>lua vim.lsp.buf.rename()<CR>')
  map('n', 'gr', '<Cmd>lua vim.lsp.buf.references()<CR>')
  map('n', '[d', '<Cmd>lua vim.diagnostic.goto_prev()<CR>')
  map('n', ']d', '<Cmd>lua vim.diagnostic.goto_next()<CR>')
  map('n', '<Leader>f', format)
  map('v', '<Leader>f', function ()
    local result = format()
    vim.api.nvim_input('<Esc>')
    return result
  end)
end

local mlsp = require('mason-lspconfig')
mlsp.setup()

local confs = {
  sumneko_lua = {
    settings = {
      Lua = {
        diagnostics = {
          globals = { 'vim' }
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

for _, name in pairs(mlsp.get_installed_servers()) do
  local settings = vim.tbl_extend(
    'force',
    { on_attach = on_attach },
    confs[name] or {}
  )
  require('lspconfig')[name].setup(settings)
end

local signs = {
  Error = ' ',
  Warn = ' ',
  Hint = ' ',
  Info = ' '
}
for type, icon in pairs(signs) do
  local hl = 'DiagnosticSign' .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end
