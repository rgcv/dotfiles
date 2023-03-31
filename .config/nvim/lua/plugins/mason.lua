return {
  {
    "williamboman/mason.nvim",
    event = "VeryLazy",
    build = ":MasonUpdate",
    config = function()
      require("mason").setup()
    end,
    dependencies = {
      "neovim/nvim-lspconfig",
      {
        "williamboman/mason-lspconfig.nvim",
        config = function()
          local mlsp = require("mason-lspconfig")
          mlsp.setup()

          local function format()
            return vim.lsp.buf.format {
              async = true,
              filter = function(client)
                return client.name ~= "null-ls"
              end
            }
          end

          local function on_attach(_, buffer)
            vim.bo[buffer].omnifunc = "v:lua.vim.lsp.omnifunc"

            local opts = { silent = true, buffer = buffer }
            local map = function(mode, lhs, rhs, desc)
              return vim.keymap.set(
                mode,
                lhs,
                rhs,
                vim.tbl_extend("force", opts, { desc = desc })
              )
            end
            map("n", "ga", "<Cmd>lua vim.lsp.buf.code_action()<CR>")
            map("n", "gD", "<Cmd>lua vim.lsp.buf.declaration()<CR>")
            map("n", "gd", "<Cmd>lua vim.lsp.buf.definition()<CR>")
            map("n", "K", "<Cmd>lua vim.lsp.buf.hover()<CR>")
            map("n", "gi", "<Cmd>lua vim.lsp.buf.implementation()<CR>")
            map("n", "<Leader>rn", "<Cmd>lua vim.lsp.buf.rename()<CR>")
            map("n", "gr", "<Cmd>lua vim.lsp.buf.references()<CR>")
            map("n", "[d", "<Cmd>lua vim.diagnostic.goto_prev()<CR>")
            map("n", "]d", "<Cmd>lua vim.diagnostic.goto_next()<CR>")
            map("n", "<Leader>f", format, "Format")
            map(
              "v",
              "<Leader>f",
              function()
                local result = format()
                vim.api.nvim_input("<Esc>")
                return result
              end,
              "Format range"
            )
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
        end,
      },
    },
  },
}
