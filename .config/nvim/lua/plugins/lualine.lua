return {

  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  opts = {
    options = {
      theme = 'auto',
      globalstatus = true,
    },
    sections = {
      lualine_a = { 'mode' },
      lualine_b = { 'branch' },
      lualine_c = {
        { 'diagnostics' },
        {
          'filetype',
          icon_only = true,
          separator = '',
          padding = { left = 1, right = 0 },
        },
        {
          'filename',
          path = 1,
          symbols = {
            modified = '●',
            readonly = '',
            unnamed = '[no name]',
          }
        },
      },
      lualine_x = {
        { 'encoding' },
        { 'fileformat' },
        { 'diff' },
      },
      lualine_y = {
        { 'progress' },
      },
      lualine_z = {
        { 'location' },
      },
    },
    extensions = { 'fugitive' }
  },

}
