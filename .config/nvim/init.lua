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
  require('plenary.reload').reload_module('init')
  dofile(vim.env.MYVIMRC)
end

vim.cmd([[
  augroup init
    autocmd!
    autocmd BufWritePost init.lua             lua ReloadConfig()
    autocmd BufWritePost lua/init/plugins.lua source <afile> | PackerCompile
    autocmd BufWritePost *nvim/lua/init/*.lua lua ReloadConfig()
  augroup end
]])
