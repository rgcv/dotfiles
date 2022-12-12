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

require('packer').startup(function(use)

  -- packer manages itself
  use 'wbthomason/packer.nvim'

  -- freemarker syntax
  use 'andreshazard/vim-freemarker'

  -- pretty diagnostic info
  use {
    'folke/trouble.nvim',
    requires = 'kyazdani42/nvim-web-devicons',
    config = [[require('plugins.trouble')]]
  }

  -- lsp-like functionality for other utilities
  use {
    'jose-elias-alvarez/null-ls.nvim',
    requires = { 'nvim-lua/plenary.nvim' },
    config = [[require('plugins.null-ls')]]
  }

  -- nvim file explorer
  use {
    'kyazdani42/nvim-tree.lua',
    requires = { 'kyazdani42/nvim-web-devicons', opt = true },
    config = [[require('plugins.nvim-tree')]]
  }

  -- web devicons (requires patched font)
  use 'kyazdani42/nvim-web-devicons'

  -- git decorations
  use {
    'lewis6991/gitsigns.nvim',
    requires = { 'nvim-lua/plenary.nvim' },
    config = [[require('plugins.gitsigns')]]
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
    config = [[require('plugins.lualine')]]
  }

  -- telescope
  use {
    'nvim-telescope/telescope.nvim',
    requires = { 'nvim-lua/plenary.nvim' },
    config = [[require('plugins.telescope')]]
  }

  -- treesitter
  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
    config = [[require('plugins.treesitter')]]
  }

  -- ansible syntax
  use 'pearofducks/ansible-vim'

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
    config = [[require('plugins.mason-lspconfig')]]
  }

  if packer_bootstrap then
    require('packer').sync()
  end

end)

vim.cmd [[
  augroup init#plugins
    au!
    au BufWritePost *nvim/lua/init/plugins.lua source <afile> | PackerCompile
    au BufWritePost *nvim/lua/plugins/*.lua    source <afile> | PackerCompile
  augroup END
]]
