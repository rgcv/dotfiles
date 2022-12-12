local map = vim.keymap.set

require('nvim-tree').setup({
  actions = {
    open_file = {
      resize_window = true
    }
  }
})

map('n', '<C-n>',     '<Cmd>NvimTreeToggle<CR>')
map('n', '<Leader>r', '<Cmd>NvimTreeRefresh<CR>')
map('n', '<Leader>n', '<Cmd>NvimTreeFindFile<CR>')
