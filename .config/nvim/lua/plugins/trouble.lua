return {
  "folke/trouble.nvim",
  dependencies = { "kyazdani42/nvim-web-devicons" },
  keys = {
    { "<Leader>xx", "<Cmd>TroubleToggle<CR>" },
  },
  config = function()
    require("trouble").setup()
  end
}
