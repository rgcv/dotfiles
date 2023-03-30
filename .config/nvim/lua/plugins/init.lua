return {
  "andreshazard/vim-freemarker",  -- freemarker syntax
  "kyazdani42/nvim-web-devicons", -- patched devicons font
  "lbrayner/vim-rzip",            -- recursive zip handling
  "mattn/emmet-vim",              -- emmet support

  -- css inline colors
  {
    "norcalli/nvim-colorizer.lua",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("colorizer").setup()
    end,
  },

  -- github theme colorscheme
  {
    "projekt0n/github-nvim-theme",
    lazy = true,
    config = function()
      require("github-theme").setup({
        transparent = true,
      })
    end,
  },

  -- auto pairing
  {
    "windwp/nvim-autopairs",
    event = "VeryLazy",
    config = true,
  },

  -- surround
  {
    "kylechui/nvim-surround",
    version = "*",
    event = "VeryLazy",
    config = true,
  },
}
