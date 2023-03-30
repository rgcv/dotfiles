return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter.configs").setup({
      ensure_installed = {
        "bibtex",
        "c",
        "cmake",
        "cpp",
        "css",
        "dockerfile",
        "go",
        "help",
        "html",
        "java",
        "javascript",
        "json",
        "julia",
        "kotlin",
        "latex",
        "lua",
        "python",
        "query",
        "scheme",
        "scss",
        "toml",
        "typescript",
        "vim",
        "yaml",
      },
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      }
    })
  end
}
