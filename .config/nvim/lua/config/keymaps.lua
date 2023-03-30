-- heavily "inspired" by https://github.com/LazyVim/LazyVim

local function map(mode, lhs, rhs, opts)
  local keys = require("lazy.core.handler").handlers.keys

  -- only map if a lazy handler already doesn't exist
  if not keys.active[keys.parse({ lhs, mode = mode }).id] then
    opts = opts or {}
    opts.silent = opts.silent ~= false
    vim.keymap.set(mode, lhs, rhs, opts)
  end
end

-- better up/down
map("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- Move to window bypassing <C-w>
map("n", "<C-h>", "<C-w><C-h>", { desc = "Go to left window" })
map("n", "<C-j>", "<C-w><C-j>", { desc = "Go to lower window" })
map("n", "<C-k>", "<C-w><C-k>", { desc = "Go to upper window" })
map("n", "<C-l>", "<C-w><C-l>", { desc = "Go to right window" })

-- Move lines
map("n", "<A-j>", "<Cmd>m .+1<CR>==", { desc = "Move down" })
map("n", "<A-k>", "<Cmd>m .-2<CR>==", { desc = "Move up" })
map("i", "<A-j>", "<Esc><Cmd>m .+1<CR>==gi", { desc = "Move down" })
map("i", "<A-k>", "<Esc><Cmd>m .-2<CR>==gi", { desc = "Move up" })
map("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move down" })
map("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move up" })

-- clear search with escape
map(
  { "i", "n" },
  "<Esc>",
  "<Cmd>noh<CR><Esc>",
  { desc = "Escape and clear hlsearch" }
)
-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
map(
  { "n", "x", "o" },
  "n",
  "'Nn'[v:searchforward]",
  { expr = true, desc = "Next search result" }
)
map(
  { "n", "x", "o" },
  "N",
  "'nN'[v:searchforward]",
  { expr = true, desc = "Prev search result" }
)

-- better indenting
map("v", "<", "<gv")
map("v", ">", ">gv")

-- auto cd to current file's working dir
map("n", "<Leader>cd", function ()
  local name = vim.fn.expand("%:p")
  if name:match("^/tmp") then
    return
  end
  vim.cmd.lcd("%:p:h")
end)

-- run current file
map("n", "<Leader>x", function() vim.cmd("!%:h/%:t") end)
