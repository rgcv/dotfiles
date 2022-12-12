
require('gitsigns').setup({
  current_line_blame = true,
  on_attach = function(_, bufnr)
    local map = vim.keymap.set
    local options =  { silent = true, buffer = bufnr }
    map({'n', 'v'}, '<Leader>hs', '<Cmd>Gitsigns stage_hunk<CR>', options)
    map({'n', 'v'}, '<Leader>hr', '<Cmd>Gitsigns reset_hunk<CR>', options)
  end
})
