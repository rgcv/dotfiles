--             _
--  _ ____   _(_)_ __ ___
-- | '_ \ \ / / | '_ ` _ \
-- | | | \ V /| | | | | | |
-- |_| |_|\_/ |_|_| |_| |_|
--

require('init.plugins')
require('init.options')
require('init.mappings')

function _G.ReloadConfig()
  if pcall(require, 'plenary') then
    require('plenary.reload').reload_module('init')
    require('init')
  end
  dofile(vim.env.MYVIMRC)
end

vim.cmd([[
  augroup init
    au!
    au BufWritePost *nvim/init.lua,*nvim/lua/init/*.lua lua ReloadConfig()
  augroup end
]])
