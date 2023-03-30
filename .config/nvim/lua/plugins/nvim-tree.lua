return {
  "kyazdani42/nvim-tree.lua",
  dependencies = { "kyazdani42/nvim-web-devicons", lazy = true },
  keys = {
    { "<C-n>", "<Cmd>NvimTreeToggle<CR>" },
    { "<Leader>r", "<Cmd>NvimTreeRefresh<CR>" },
    { "<Leader>n", "<Cmd>NvimTreeFindFile<CR>" },
  },
  config = function()
    require("nvim-tree").setup()
  end
}
