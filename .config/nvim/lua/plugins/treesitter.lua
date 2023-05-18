return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      "nvim-treesitter/nvim-treesitter-context",
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    opts = {
      highlight = { enable = true },
      indent = { enable = true },
      ensure_installed = {
        -- always
        "c",
        "lua",
        "vim",
        "vimdoc",
        "query",

        -- additional
        "bash",
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
        "markdown",
        "markdown_inline",
        "python",
        "regex",
        "scheme",
        "scss",
        "toml",
        "tsx",
        "typescript",
        "yaml",
      },
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
  },
}
