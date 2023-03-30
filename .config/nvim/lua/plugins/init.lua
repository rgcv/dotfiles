return {
  -- emmet
  "mattn/emmet-vim",

  -- css inline colors
  {
    "norcalli/nvim-colorizer.lua",
    config = function()
      require("colorizer").setup()
    end
  },

  -- web devicons (dependencies patched font)
  "kyazdani42/nvim-web-devicons",

  -- freemarker syntax
  "andreshazard/vim-freemarker",

  -- recursive zip handling
  "lbrayner/vim-rzip",

  -- robust module reloading
  "nvim-lua/plenary.nvim",

  -- github theme colorscheme
  {
    "projekt0n/github-nvim-theme",
    lazy = true,
    config = function()
      require("github-theme").setup({
        transparent = true,
      })
    end
  },

  -- auto pairing
  {
    "windwp/nvim-autopairs",
    event = "VeryLazy",
    config = function()
      require("nvim-autopairs").setup()
    end,
  },
}
