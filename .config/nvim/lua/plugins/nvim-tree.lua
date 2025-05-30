return {
  'nvim-tree/nvim-tree.lua',
  event = 'VeryLazy',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  keys = {
    { '<C-n>', '<Cmd>NvimTreeToggle<CR>' },
    { '<Leader>r', '<Cmd>NvimTreeRefresh<CR>' },
    { '<Leader>n', '<Cmd>NvimTreeFindFile<CR>' },
  },
  config = true,
}
