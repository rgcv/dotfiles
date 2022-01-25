local map = vim.api.nvim_set_keymap

local function nmap(...)
  return vim.api.nvim_set_keymap('n', ...)
end

local function tmap(...)
  return vim.api.nvim_set_keymap('t', ...)
end

local function nnoremap(lhs, rhs, opts)
  opts = opts or {}
  opts.noremap = true
  return nmap(lhs, rhs, opts)
end

local function tnoremap(lhs, rhs, opts)
  opts = opts or {}
  opts.noremap = true
  return tmap(lhs, rhs, opts)
end

-- auto cd to current file's working dir
function _G.AutoCD()
  local name = vim.fn.expand('%:p')
  if name:match('^/tmp') then
    return
  end
  vim.cmd('lcd %:p:h')
end
nnoremap('<Leader>cd', '<Cmd>lua AutoCD()<CR>:pwd<CR>')
-- run current file
nnoremap('<Leader>x', '<Cmd>!%:h/%:t<CR>')
-- reload config
nnoremap('<Leader>vs', '<Cmd>ReloadConfig<CR>')

-- exit terminal mode on escape
tnoremap('<Esc>', '<C-\\><C-n>')
