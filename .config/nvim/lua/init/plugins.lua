local install_path = vim.fn.stdpath('data')..'/site/pack/packer/opt/packer.nvim'
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  packer_bootstrap = vim.fn.system({
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
          nls.builtins.diagnostics.luacheck.with({
            extra_args = { '--globals', 'vim' }
          }),
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
          local gs = package.loaded.gitsigns

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

        set('omnifunc', 'v:lua.vim.lsp.omnifunc')

        nmap('gD',         '<Cmd>lua vim.lsp.buf.declaration()<CR>')
        nmap('gd',         '<Cmd>lua vim.lsp.buf.definition()<CR>')
        nmap('K',          '<Cmd>lua vim.lsp.buf.hover()<CR>')
        nmap('gi',         '<Cmd>lua vim.lsp.buf.implementation()<CR>')
        nmap('<C-k>',      '<Cmd>lua vim.lsp.buf.signature_help()<CR>')
        nmap('<Leader>rn', '<Cmd>lua vim.lsp.buf.rename()<CR>')
        nmap('gr',         '<Cmd>lua vim.lsp.buf.references()<CR>')
        nmap('[d',         '<Cmd>lua vim.diagnostic.goto_prev()<CR>')
        nmap(']d',         '<Cmd>lua vim.diagnostic.goto_next()<CR>')
        nmap('<Leader>f',  '<Cmd>lua vim.lsp.buf.formatting()<CR>')
        vmap('<Leader>f',  '<Cmd>lua vim.lsp.buf.range_formatting()<CR>')
      end

      -- setup once ready
      lspi.on_server_ready(function(server)
        server:setup({
          on_attach = function(client, bufnr)
            if server.name == 'tsserver' then
              client.resolved_capabilities.document_formatting = false
              client.resolved_capabilities.document_range_formatting = false
            end
            return on_attach(client, bufnr)
          end
        })
      end)

      local signs = {
        Error = " ",
        Warn = " ",
        Hint = " ",
        Info = " "
      }
      for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
      end
    end
  }

  if packer_bootstrap then
    require('packer').sync()
  end
end)
