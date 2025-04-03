return {
  'kristijanhusak/vim-dadbod-ui',
  event = 'VeryLazy',
  dependencies = { 'tpope/vim-dadbod' },
  config = function()
    vim.g.db_ui_use_nerd_fonts = 1
  end
}
