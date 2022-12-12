local function filename()
  if vim.bo.filetype == 'help' then
    return vim.fn.expand('%:t')
  end
  if vim.bo.filetype == 'packer' then
    return ''
  end

  local name = vim.fn.expand('%:~:.')
  if name ~= '' then
    return name .. (vim.bo.modified and '*' or '')
  end

  return '[no name]'
end

require('lualine').setup({
  options = {
    theme = 'github_dark',
  },
  sections = {
    lualine_c = {
      { filename },
      { "vim.bo.readonly and 'readonly' or ''" }
    }
  },
  inactive_sections = {
    lualine_c = { { filename } }
  },
  extensions = { 'fugitive' }
})
