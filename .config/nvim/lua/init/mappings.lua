local map = vim.api.nvim_set_keymap

local function noremap(mode, lhs, rhs, opts)
  opts = vim.tbl_extend('force', opts or {}, { noremap = true })
  return map(mode, lhs, rhs, opts)
end

local function nnoremap(...) return noremap('n', ...) end

-- auto cd to current file's working dir
function _G.AutoCD()
  local name = vim.fn.expand('%:p')
  if name:match('^/tmp') then
    return
  end
  vim.cmd [[lcd %:p:h]]
end

nnoremap('<Leader>cd', '<Cmd>lua AutoCD()<CR>:pwd<CR>')
-- run current file
nnoremap('<Leader>x', '<Cmd>!%:h/%:t<CR>')
-- reload config
nnoremap('<Leader>vs', '<Cmd>lua ReloadConfig()<CR>')
