return {

  {
    'nvimtools/none-ls.nvim',
    event = 'BufReadPre',
    dependencies = {
      'gbprod/none-ls-shellcheck.nvim',
    },
    config = function()
      local nls = require('null-ls')
      nls.setup({
        sources = {
          require('none-ls-shellcheck.code_actions'),
          require('none-ls-shellcheck.diagnostics').with({
            diagnostics_format = '[SC#{c}] #{m}',
          }),
          nls.builtins.diagnostics.vint,
          nls.builtins.formatting.prettier.with({
            prefer_local = 'node_modules/.bin'
          }),
        }
      })
    end
  },

  {
    'mason-org/mason-lspconfig.nvim',
    dependencies = {
      { 'mason-org/mason.nvim', opts = {} },
      'neovim/nvim-lspconfig',
      'hrsh7th/cmp-nvim-lsp',
    },
    opts = {
      ensure_installed = { 'lua_ls' },
    },
    init = function()
      vim.opt.signcolumn = 'yes'
    end,
    config = function(_, opts)
      local lsp_defaults = require('lspconfig').util.default_config
      lsp_defaults.capabilities = vim.tbl_deep_extend(
        'force',
        lsp_defaults.capabilities,
        require('cmp_nvim_lsp').default_capabilities()
      )

      vim.api.nvim_create_autocmd('LspAttach', {
        callback = function(event)
          local function map(mode, l, r)
            vim.keymap.set(mode, l, r, { buffer = event.buf })
          end
          map('n', 'K', vim.lsp.buf.hover)
          map('n', 'gd', vim.lsp.buf.definition)
          map('n', 'gD', vim.lsp.buf.declaration)
          map('n', 'gi', vim.lsp.buf.implementation)
          map('n', 'go', vim.lsp.buf.type_definition)
          map('n', 'gr', vim.lsp.buf.references)
          map('n', 'gs', vim.lsp.buf.signature_help)
          map('n', 'gl', vim.diagnostic.open_float)
          map('n', '<Leader>rn', vim.lsp.buf.rename)
          map({ 'n', 'x' }, '<Leader>f', function() vim.lsp.buf.format({ async = true }) end)
          map('n', 'ga', vim.lsp.buf.code_action)

          vim.bo[event.buf].formatexpr = 'v:lua.vim.lsp.formatexpr()'
          vim.bo[event.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'
          vim.bo[event.buf].tagfunc = 'v:lua.vim.lsp.tagfunc'
        end
      })

      vim.lsp.config('lua_ls', {
        settings = {
          Lua = {
            runtime = {
              version = 'LuaJIT',
            },
            diagnostics = {
              globals = {
                'vim',
                'require',
              },
            },
          },
        },
        on_init = function(client)
          local join = vim.fs.joinpath
          local folders = client.workspace_folders
          if not folders then
            return
          end

          local path = folders[1].name
          if vim.uv.fs_stat(join(path, '.luarc.json'))
              or vim.uv.fs_stat(join(path, '.luarc.jsonc'))
          then
            return
          end

          local nvim_settings = {
            runtime = {
              version = 'LuaJIT'
            },
            diagnostics = {
              globals = { 'vim' }
            },
            workspace = {
              checkThirdParty = false,
              library = {
                vim.env.RUNTIME,
                vim.fn.stdpath('config')
              }
            },
          }

          client.config.settings.Lua = vim.tbl_deep_extend(
            'force',
            client.config.settings.Lua,
            nvim_settings
          )
        end
      })

      require('mason-lspconfig').setup(opts)

      vim.diagnostic.config({
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = '󰅚',
            [vim.diagnostic.severity.WARN] = '󰀪',
            [vim.diagnostic.severity.HINT] = '󰗖',
            [vim.diagnostic.severity.INFO] = '󰋽',
          }
        }
      })
    end,
  }
}
