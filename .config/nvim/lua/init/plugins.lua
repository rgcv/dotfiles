local ensure_packer = function()
  local fn = vim.fn
  local path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(path)) > 0 then
    fn.system({
      'git', 'clone',
      '--depth', '1',
      'https://github.com/wbthomason/packer.nvim',
      path
    })
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

local packer = require('packer')
packer.startup(function()
  local use = packer.use

  -- packer manages itself
  use 'wbthomason/packer.nvim'

  -- freemarker syntax
  use 'andreshazard/vim-freemarker'
  -- nginx syntax
  use 'chr4/nginx.vim'
  -- pretty diagnostic info
  use {
    'folke/trouble.nvim',
    requires = 'kyazdani42/nvim-web-devicons',
    config = function()
      require('trouble').setup()
      local function map(mode, lhs, rhs, opts)
        opts = vim.tbl_extend(
          'force',
          {
            noremap = true,
            silent = true
          },
          opts or {})
        return vim.keymap.set(mode, lhs, rhs, opts)
      end

      map('n', '<Leader>xx', '<Cmd>TroubleToggle<CR>')
    end
  }
  -- lsp-like functionality for other utilities
  use {
    'jose-elias-alvarez/null-ls.nvim',
    requires = { 'nvim-lua/plenary.nvim' },
    config = function()
      local nls = require('null-ls')
      nls.setup({
        sources = {
          nls.builtins.code_actions.gitsigns,
          nls.builtins.diagnostics.shellcheck.with({
            diagnostics_format = "[SC#{c}] #{m}"
          }),
          nls.builtins.diagnostics.vint,
          nls.builtins.formatting.prettier.with({
            prefer_local = 'node_modules/.bin',
          }),
        }
      })
    end
  }
  -- auto away hl
  use 'junegunn/vim-slash'
  -- nvim file explorer
  use {
    'kyazdani42/nvim-tree.lua',
    requires = { 'kyazdani42/nvim-web-devicons', opt = true },
    config = function()
      local function map(mode, lhs, rhs, opts)
        opts = vim.tbl_extend('force', { noremap = true }, opts or {})
        return vim.keymap.set(mode, lhs, rhs, opts)
      end
      local function nmap(...) return map('n', ...) end

      nmap('<C-n>',     '<Cmd>NvimTreeToggle<CR>')
      nmap('<Leader>r', '<Cmd>NvimTreeRefresh<CR>')
      nmap('<Leader>n', '<Cmd>NvimTreeFindFile<CR>')

      require('nvim-tree').setup({
        actions = {
          open_file = {
            resize_window = true
          }
        }
      })
    end
  }
  -- web devicons (requires patched font)
  use 'kyazdani42/nvim-web-devicons'
  -- git decorations
  use {
    'lewis6991/gitsigns.nvim',
    requires = { 'nvim-lua/plenary.nvim' },
    config = function()
      require('gitsigns').setup({
        current_line_blame = true,
        on_attach = function(_, bufnr)
          local function map(mode, lhs, rhs, opts)
            opts = vim.tbl_extend(
              'force',
              {
                noremap = true,
                silent = true,
                buffer = bufnr
              },
              opts or {})
            vim.keymap.set(mode, lhs, rhs, opts)
          end

          map({'n', 'v'}, '<Leader>hs', '<Cmd>Gitsigns stage_hunk<CR>')
          map({'n', 'v'}, '<Leader>hr', '<Cmd>Gitsigns reset_hunk<CR>')
        end
      })
    end
  }
  -- strip whitespace
  use {
    'lewis6991/spaceless.nvim',
    config = function()
      require('spaceless').setup()
    end
  }
  -- emmet
  use 'mattn/emmet-vim'
  -- robust module reloading
  use 'nvim-lua/plenary.nvim'
  -- statusline
  use {
    'nvim-lualine/lualine.nvim',
    after = 'github-nvim-theme',
    requires = { 'kyazdani42/nvim-web-devicons', opt = true },
    config = function()
      local function filename()
        if vim.bo.filetype == 'help' then
          return vim.fn.expand('%:t')
        end
        if vim.bo.filetype == 'packer' then
          return ''
        end

        local name = vim.fn.expand('%:~:.')
        if name ~= '' then
          return name .. (vim.bo.modified and '*' or '')
        end

        return '[no name]'
      end

      require('lualine').setup({
        options = {
          theme = 'github_dark',
        },
        sections = {
          lualine_c = {
            { filename },
            { "vim.bo.readonly and 'readonly' or ''" }
          }
        },
        inactive_sections = {
          lualine_c = { { filename } }
        },
        extensions = { 'fugitive' }
      })
    end
  }
  -- telescope
  use {
    'nvim-telescope/telescope.nvim',
    requires = { 'nvim-lua/plenary.nvim' },
    config = function()
      local function map(mode, lhs, rhs, opts)
        local o = vim.tbl_extend('force', { noremap = true }, opts or {})
        return vim.keymap.set(mode, lhs, rhs, o)
      end
      local function nmap(...) map('n', ...) end

      nmap('<Leader>tf', '<Cmd>Telescope find_files<CR>')
      nmap('<Leader>tg', '<Cmd>Telescope live_grep<CR>')
    end
  }
  -- treesitter
  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
    config = function()
      require('nvim-treesitter.configs').setup({
        ensure_installed = {
          'bibtex',
          'c',
          'cmake',
          'cpp',
          'css',
          'dockerfile',
          'go',
          'html',
          'java',
          'javascript',
          'json',
          'julia',
          'kotlin',
          'latex',
          'lua',
          'python',
          'scheme',
          'scss',
          'toml',
          'typescript',
          'vim',
          'yaml',
        },
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        }
      })
    end
  }
  -- ansible syntax
  use 'pearofducks/ansible-vim'
  -- i3 syntax
  use 'Potatoesmaster/i3-vim-syntax'
  -- github theme colorscheme
  use {
    'projekt0n/github-nvim-theme',
    after = {
      'gitsigns.nvim',
      'nvim-tree.lua',
    },
    config = function()
      require('github-theme').setup({
        theme_style = 'dark',
        transparent = true
      })
    end
  }
  -- auto pairing
  use {
    'windwp/nvim-autopairs',
    config = function()
      require('nvim-autopairs').setup()
    end
  }

  -- vimpope's suite of goodness
  use 'tpope/vim-apathy'
  use 'tpope/vim-commentary'
  use 'tpope/vim-endwise'
  use {
    'tpope/vim-rhubarb',
    requires = { 'tpope/vim-fugitive' }
  }
  use 'tpope/vim-repeat'
  use 'tpope/vim-sleuth'
  use 'tpope/vim-surround'

  -- LSP server config
  use {
    'williamboman/mason.nvim',
    config = function()
      require('mason').setup()
    end
  }
  use {
    'williamboman/mason-lspconfig.nvim',
    requires = { 'neovim/nvim-lspconfig' },
    after = { 'mason.nvim' },
    config = function()
      local on_attach = function(_, bufnr)
        local function map(mode, lhs, rhs, opts)
          opts = vim.tbl_extend(
            'force',
            {
              noremap = true,
              silent = true,
              buffer = bufnr
            },
            opts or {})
          vim.keymap.set(mode, lhs, rhs, opts)
        end
        local function nmap(...) return map('n', ...) end
        local function vmap(...) return map('v', ...) end
        local function set(...) vim.api.nvim_buf_set_option(bufnr, ...) end

        set('omnifunc', 'v:lua.vim.lsp.omnifunc')

        nmap('ga', '<Cmd>lua vim.lsp.buf.code_action()<CR>')
        nmap('gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>')
        nmap('gd', '<Cmd>lua vim.lsp.buf.definition()<CR>')
        nmap('K', '<Cmd>lua vim.lsp.buf.hover()<CR>')
        nmap('gi', '<Cmd>lua vim.lsp.buf.implementation()<CR>')
        nmap('<C-k>', '<Cmd>lua vim.lsp.buf.signature_help()<CR>')
        nmap('<Leader>rn', '<Cmd>lua vim.lsp.buf.rename()<CR>')
        nmap('gr', '<Cmd>lua vim.lsp.buf.references()<CR>')
        nmap('[d', '<Cmd>lua vim.diagnostic.goto_prev()<CR>')
        nmap(']d', '<Cmd>lua vim.diagnostic.goto_next()<CR>')
        nmap('<Leader>f', '<Cmd>lua vim.lsp.buf.format { async = true }<CR>')
        vmap('<Leader>f', '<Cmd>lua vim.lsp.buf.format { async = true }<CR>')
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
    end
  }

  if packer_bootstrap then
    packer.sync()
  end
end)
