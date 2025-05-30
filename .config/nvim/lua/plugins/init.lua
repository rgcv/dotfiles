return {

  'andreshazard/vim-freemarker',                  -- freemarker syntax
  { 'nvim-tree/nvim-web-devicons', lazy = true }, -- nerd font icons
  'lbrayner/vim-rzip',                            -- recursive zip handling
  'mattn/emmet-vim',                              -- emmet support

  -- color theme
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    priority = 1000,
    init = function() vim.cmd.colorscheme('catppuccin') end,
    opts = {
      transparent_background = true,
      integrations = {
        octo = true,
      },
    },
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
