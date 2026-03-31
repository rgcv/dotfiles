return {

  'andreshazard/vim-freemarker', -- freemarker syntax
  { 'nvim-tree/nvim-web-devicons', lazy = true }, -- nerd font icons
  'lbrayner/vim-rzip', -- recursive zip handling

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

  -- markdown
  {
    'OXY2DEV/markview.nvim',
    lazy = false,
  },

  -- surround
  {
    'kylechui/nvim-surround',
    version = '*',
    event = 'VeryLazy',
    config = true,
  },

}
