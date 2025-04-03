local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    'git', 'clone',
    '--branch=stable',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    lazypath
  })
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup('plugins')
