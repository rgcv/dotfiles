return {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    signs = {
      add = { text = "▎" },
      change = { text = "▎" },
      delete = { text = "" },
      topdelete = { text = "" },
      changedelete = { text = "▎" },
      untracked = { text = "▎" },
    },
    current_line_blame = true,
    on_attach = function(buffer)
      local gs = package.loaded.gitsigns
      local function map(mode, lhs, rhs, desc)
        vim.keymap.set(mode, lhs, rhs, { buffer = buffer, desc = desc })
      end

      map("n", "]h", gs.next_hunk, "Next hunk")
      map("n", "[h", gs.prev_hunk, "Previous hunk")
      map({ "n", "v" }, "<Leader>ghs", "<Cmd>Gitsigns stage_hunk<CR>", "Stage hunk")
      map({ "n", "v" }, "<Leader>ghr", "<Cmd>Gitsigns reset_hunk<CR>", "Reset hunk")
      map("n", "<Leader>ghb", function() gs.blame_line({ full = true }) end, "Blame line")
      map("n", "<Leader>ghd", gs.diffthis, "Diff this")
      map("n", "<Leader>ghD", function() gs.diffthis("~") end, "Diff this")
    end
  },
}
