local   g = vim.g
local opt = vim.opt

opt.clipboard = opt.clipboard + { 'unnamed', 'unnamedplus' }
opt.colorcolumn = { '+1', '120' }
opt.conceallevel = 2
opt.expandtab = true
opt.list = true
opt.listchars = { nbsp = '+', space = '·', tab = '→ ' }
opt.mouse = 'a'
opt.number = true
opt.path = (opt.path - '.') ^ { '.', '**' }
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.signcolumn = 'number'
opt.shiftwidth = 2
opt.undofile = true
opt.wrap = false

g.mapleader = ','
g.maplocalleader = ' '

function _G.SetTextWidth()
  if vim.bo.textwidth == 0 then
    vim.bo.textwidth = 80
  end
end

vim.cmd([[
  augroup init#options
    au!
    au FileType * lua SetTextWidth()
  augroup end
]])
