--             _
--  _ ____   _(_)_ __ ___
-- | '_ \ \ / / | '_ ` _ \
-- | | | \ V /| | | | | | |
-- |_| |_|\_/ |_|_| |_| |_|

require("config.options")
require("config.plugins")

if vim.fn.argc(-1) == 0 then
  -- postpone autocmds and keymaps
  vim.api.nvim_create_autocmd("User", {
    group = vim.api.nvim_create_augroup("init", { clear = true }),
    callback = function()
      require("config.autocmds")
      require("config.keymaps")
    end,
  })
else
  -- unless we ran with files
  require("config.autocmds")
  require("config.keymaps")
end

vim.cmd.colorscheme("github_dark")
