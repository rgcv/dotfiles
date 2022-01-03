--             _
--  _ ____   _(_)_ __ ___
-- | '_ \ \ / / | '_ ` _ \
-- | | | \ V /| | | | | | |
-- |_| |_|\_/ |_|_| |_| |_|
--

require('init.plugins')
require('init.options')
require('init.mappings')

local map = vim.api.nvim_set_keymap

function _G.ReloadConfig()
  require('plenary.reload').reload_module('init')
  dofile(vim.env.MYVIMRC)
end
vim.cmd('command! ReloadConfig lua ReloadConfig()')

function _G.StripTrailingWhitespace()
  local l = vim.fn.line('.')
  local c = vim.fn.col('.')
  vim.cmd([[%s/\s\+$//e]])
  vim.fn.cursor(l, c)
end

vim.cmd([[
  augroup init
    autocmd!

    autocmd BufWritePost init.lua             ReloadConfig
    autocmd BufWritePost *nvim/lua/init/*.lua ReloadConfig

    " trim trailing whitespace
    autocmd BufWritePre    * lua StripTrailingWhitespace()
    autocmd FileAppendPre  * lua StripTrailingWhitespace()
    autocmd FileWritePre   * lua StripTrailingWhitespace()
    autocmd FilterWritePre * lua StripTrailingWhitespace()
  augroup end
]])
