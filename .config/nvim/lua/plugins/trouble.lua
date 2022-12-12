local map = vim.api.nvim_set_keymap

require('trouble').setup()

local options = { silent = true, noremap = true }
map('n', '<Leader>xx', '<Cmd>TroubleToggle<CR>', options)
