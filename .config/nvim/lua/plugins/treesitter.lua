return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          -- always
          "c",
          "lua",
          "vim",
          "help",
          "query",

          -- additional
          "bibtex",
          "cmake",
          "cpp",
          "css",
          "dockerfile",
          "go",
          "html",
          "java",
          "javascript",
          "jsdoc",
          "json",
          "julia",
          "kotlin",
          "latex",
          "luadoc",
          "python",
          "scheme",
          "scss",
          "toml",
          "typescript",
          "yaml",
        },
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        }
      })
    end,
  }
}
