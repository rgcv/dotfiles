return {
  'catppuccin/nvim',
  name = 'catppuccin',
  priority = 1000,
  init = function() vim.cmd.colorscheme('catppuccin-nvim') end,
  opts = {
    transparent_background = true,
    auto_integrations = true,
  },
}
