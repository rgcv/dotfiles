local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/opt/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({
    'git', 'clone',
    '--depth', '1',
    'https://github.com/wbthomason/packer.nvim',
    install_path
  })
end

vim.cmd('packadd packer.nvim')
require('packer').startup(function()
  -- packer manages itself
  use { 'wbthomason/packer.nvim', opt = true }

  -- freemarker syntax
  use 'andreshazard/vim-freemarker'
  -- nginx syntax
  use 'chr4/nginx.vim'
  -- lsp-like functionality for other utilities
  use {
    'jose-elias-alvarez/null-ls.nvim',
    requires = { 'nvmi-lua/plenary.nvim' },
    config = function()
      local nls = require('null-ls')
      nls.setup({
        sources = {
          nls.builtins.code_actions.gitsigns,
          nls.builtins.diagnostics.luacheck.with({
            extra_args = { '--globals', 'vim' }
          }),
          nls.builtins.diagnostics.shellcheck,
          nls.builtins.diagnostics.vint,
        }
      })
    end
  }
  -- auto away hl
  use 'junegunn/vim-slash'
  -- git decorations
  use {
    'lewis6991/gitsigns.nvim',
    requires = { 'nvim-lua/plenary.nvim' },
    config = function()
      require('gitsigns').setup({
        current_line_blame = true
      })
    end
  }
  -- nvim file explorer
  use {
    'kyazdani42/nvim-tree.lua',
    requires = { 'kyazdani42/nvim-web-devicons', opt = true },
    config = function()
      local map = vim.api.nvim_set_keymap
      map('n', '<C-n>', '<Cmd>NvimTreeToggle<CR>', { noremap = true })
      map('n', '<Leader>r', '<Cmd>NvimTreeRefresh<CR>', { noremap = true })
      map('n', '<Leader>n', '<Cmd>NvimTreeFindFile<CR>', { noremap = true })
      require('nvim-tree').setup({
        auto_close = true,
        view = {
          auto_resize = true
        }
      })
    end
  }
  -- web devicons (requires patched font)
  use 'kyazdani42/nvim-web-devicons'
  -- emmet
  use 'mattn/emmet-vim'
  -- filetype for nvim
  use 'nathom/filetype.nvim'
  -- robust module reloading
  use 'nvim-lua/plenary.nvim'
  -- statusline
  use {
    'nvim-lualine/lualine.nvim',
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
          theme = 'github',
        },
        sections = {
          lualine_c = {
            {filename},
            {"vim.bo.readonly and 'readonly' or ''"}
          }
        },
        inactive_sections = {
          lualine_c = {{filename}}
        },
        extensions = {'fugitive'}
      })
    end
  }
  -- treesitter
  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
    config = function()
      require('nvim-treesitter.configs').setup({
        ensure_installed = 'maintained',
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
      'lualine.nvim',
      'gitsigns.nvim',
      'nvim-tree.lua',
    },
    config = function()
      require('github-theme').setup({
        theme_style = 'dark_default',
        transparent = true
      })
    end
  }
  -- auto pairing
  use {
    'steelsojka/pears.nvim',
    config = function()
      require('pears').setup(function(conf)
        conf.preset('tag_matching')
      end)
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

  -- install lsp servers
  use {
    'williamboman/nvim-lsp-installer',
    requires = { 'neovim/nvim-lspconfig' },
    config = function()
      local lspi = require('nvim-lsp-installer')
      -- settings and bindings to run when lsp attaches to buffer
      local on_attach = function(_, bufnr)
        local function set(...) vim.api.nvim_buf_set_option(bufnr, ...) end
        local function map(mode, lhs, rhs, opts)
          opts = opts or {}
          opts.noremap = true
          opts.silent = true
          vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, opts)
        end
        local function nmap(...) map('n', ...) end

        set('omnifunc', 'v:lua.vim.lsp.omnifunc')

        nmap('gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>')
        nmap('gd', '<Cmd>lua vim.lsp.buf.definition()<CR>')
        nmap('K', '<Cmd>lua vim.lsp.buf.hover()<CR>')
        nmap('gi', '<Cmd>lua vim.lsp.buf.implementation()<CR>')
        nmap('<C-k>', '<Cmd>lua vim.lsp.buf.signature_help()<CR>')
        nmap('<Leader>rn', '<Cmd>lua vim.lsp.buf.rename()<CR>')
        nmap('gr', '<Cmd>lua vim.lsp.buf.references()<CR>')
        nmap('[d', '<Cmd>lua vim.diagnostic.goto_prev()<CR>')
        nmap(']d', '<Cmd>lua vim.diagnostic.goto_next()<CR>')
        nmap('<Leader>f', '<Cmd>lua vim.lsp.buf.formatting()<CR>')
      end

      -- check and install a few servers
      local servers = {
        'clangd',
        'ltex',
        'tsserver',
      }
      for _, name in pairs(servers) do
        local found, lsp = lspi.get_server(name)
        if found then
          if not lsp:is_installed() then
            print('Installing ' .. name)
            lsp:install()
          end
        end
      end

      -- setup once ready
      lspi.on_server_ready(function(server)
        server:setup({ on_attach = on_attach })
      end)
    end
  }

  if packer_bootstrap then
    require('packer').sync()
  end
end)
