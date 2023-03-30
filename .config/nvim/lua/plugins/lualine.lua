return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  dependencies = { "kyazdani42/nvim-web-devicons", lazy = true },
  config = function()
    require('lualine').setup({
      options = {
        theme = "auto",
        globalstatus = true,
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch" },
        lualine_c = {
          { "diagnostics" },
          {
            "filetype",
            icon_only = true,
            separator = "",
            padding = { left = 1, right = 0 },
          },
          {
            "filename",
            path = 1,
            symbols = {
              modified = "*",
              readonly = "readonly",
              unnamed = "[no name]",
            }
          },
        },
        lualine_x = {
          { "encoding" },
          { "fileformat" },
          { "diff" },
        },
        lualine_y = {
          { "progress" },
        },
        lualine_z = {
          { "location"},
        },
      },
      inactive_sections = {
        lualine_c = { { filename } }
      },
      extensions = { "fugitive" }
    })
  end
}
