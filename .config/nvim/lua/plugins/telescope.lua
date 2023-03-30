return {
  "nvim-telescope/telescope.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  keys = {
    {
      "<Leader>tf",
      function()
        local builtin
        local opts = {}
        if vim.loop.fs_stat(vim.loop.cwd() .. "/.git") then
          opts.show_untracked = true
          builtin = "git_files"
        else
          builtin = "find_files"
        end
        require("telescope.builtin")[builtin](opts)
      end
    },
    { "<Leader>tg", function() require("telescope.builtin").live_grep() end },
  },
}
