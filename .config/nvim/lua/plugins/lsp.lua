return {
  -- Autocompletion
  {
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    config = function()
      local cmp = require('cmp')

      cmp.setup({
        sources = { name = 'nvim_lsp' },
        mapping = cmp.mapping.preset.insert({
          ['<TAB>'] = cmp.mapping.confirm({ select = true }),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-u>'] = cmp.mapping.scroll_docs(-4),
          ['<C-d>'] = cmp.mapping.scroll_docs(4),
        }),
        snippet = {
          expand = function(args)
            vim.snippet.expand(args.body)
          end
        },
      })
    end
  },

  {
    'williamboman/mason.nvim',
    lazy = false,
    opts = {}
  },

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

  -- LSP
  {
    'neovim/nvim-lspconfig',
    cmd = { 'LspInfo', 'LspInstall', 'LspStart' },
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
      { 'hrsh7th/cmp-nvim-lsp' },
      { 'williamboman/mason.nvim' },
      { 'williamboman/mason-lspconfig.nvim' },
    },
    init = function()
      vim.opt.signcolumn = 'yes'
    end,
    config = function()
      local lsp_defaults = require('lspconfig').util.default_config
      lsp_defaults.capabilities = vim.tbl_deep_extend(
        'force',
        lsp_defaults.capabilities,
        require('cmp_nvim_lsp').default_capabilities()
      )

      vim.api.nvim_create_autocmd('LspAttach', {
        callback = function(event)
          local opts = { buffer = event.buf }
          vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
          vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
          vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
          vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
          vim.keymap.set('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
          vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
          vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
          vim.keymap.set('n', 'gl', '<cmd>lua vim.diagnostic.open_float()<cr>', opts)
          vim.keymap.set('n', '<Leader>rn', '<Cmd>lua vim.lsp.buf.rename()<CR>', opts)
          vim.keymap.set({'n', 'x'}, '<Leader>f', '<Cmd>lua vim.lsp.buf.format({ async = true })<CR>', opts)
          vim.keymap.set('n', 'ga', '<Cmd>lua vim.lsp.buf.code_action()<CR>', opts)
        end
      })

      require('mason-lspconfig').setup({
        ensure_installed = {
          'lua_ls'
        },
        handlers = {
          function(server_name)
            require('lspconfig')[server_name].setup({})
          end,

          lua_ls = function()
            require('lspconfig').lua_ls.setup({
              diagnostics = {
                globals = { 'vim' },
              },
              workspace = {
                library = {
                  vim.env.VIMRUNTIME,
                },
              },
            })
          end,
        }
      })

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
