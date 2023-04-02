-- heavily "inspired" by https://github.com/LazyVim/LazyVim

local function augroup(name)
  return vim.api.nvim_create_augroup("init#" .. name, { clear = true })
end

local autocmd = vim.api.nvim_create_autocmd

-- Check if we need to reload a file if it changed
autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  group = augroup("checktime"),
  command = "checktime",
})

-- Resize splits on window resize
autocmd("VimResized", {
  group = augroup("resize_splits"),
  callback = function()
    vim.cmd("tabdo wincmd =")
  end,
})

-- Close some filetypes with <Q> instead of <Cr> or <Esc>
autocmd("FileType", {
  group = augroup("close_with_q"),
  pattern = {
    "PlenaryTestPopup",
    "help",
    "lspinfo",
    "man",
    "notify",
    "qf",
    "spectre_panel",
    "startuptime",
    "tsplayground",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<Cmd>close<CR>", { buffer = event.buf, silent = true })
  end,
})

-- Check for spelling in some files
autocmd("FileType", {
  group = augroup("spelling"),
  pattern = { "gitcommit", "markdown", "tex" },
  callback = function()
    vim.opt_local.spell = true
  end,
})

-- Try and set a proper default textwidth
autocmd("FileType", {
  group = augroup("textwidth"),
  callback = function()
    if vim.bo.textwidth == 0 then
      vim.bo.textwidth = 80
    end
  end,
})
