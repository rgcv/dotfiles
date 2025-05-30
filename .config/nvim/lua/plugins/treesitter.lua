local installed = {}
local function on_filetype(args)
  local function load(lang)
    local ts = require('nvim-treesitter')
    if not installed[lang] and vim.tbl_contains(ts.get_available(), lang) then
      ts.install(lang):await(function()
        installed[lang] = true
        load(lang)
      end)
      return
    elseif not vim.treesitter.language.add(lang) then
      return
    end

    vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
    vim.bo.indentexpr = "v:lua.require('nvim-treesitter').indentexpr()"
    vim.treesitter.start()
  end

  load(vim.treesitter.language.get_lang(args.match))
end

return {

  {
    'nvim-treesitter/nvim-treesitter',
    lazy = false,
    branch = 'main',
    build = ':TSUpdate',
    init = function()
      installed = require('nvim-treesitter').get_installed()
      vim.api.nvim_create_autocmd('FileType', { callback = on_filetype })
    end,
  },

  { 'windwp/nvim-ts-autotag', opts = {} },

}
