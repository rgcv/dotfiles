return {
  "folke/trouble.nvim",
  dependencies = { "kyazdani42/nvim-web-devicons" },
  keys = {
    { "<Leader>xx", "<Cmd>TrobleToggle<CR>" },
  },
  config = function()
    require("trouble").setup()
  end
}
