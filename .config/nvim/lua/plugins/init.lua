return {

  'andreshazard/vim-freemarker',  -- freemarker syntax
  'nvim-tree/nvim-web-devicons',  -- patched devicons font
  'lbrayner/vim-rzip',            -- recursive zip handling
  'mattn/emmet-vim',              -- emmet support

  -- color theme
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    priority = 1000,
    config = function()
      require('catppuccin').setup({
        transparent_background = true,
      })
      vim.cmd.colorscheme('catppuccin')
    end
  },

  -- css inline colors
  {
    'catgoose/nvim-colorizer.lua',
    event = 'BufReadPre',
    opts = {},
  },

  -- auto pairing
  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    config = true,
  },

  -- comment
  {
    'numToStr/Comment.nvim',
    config = true,
  },

  -- surround
  {
    'kylechui/nvim-surround',
    version = '*',
    event = 'VeryLazy',
    config = true,
  },

}
