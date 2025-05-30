return {

  {
    'nvim-treesitter/nvim-treesitter',
    lazy = false,
    branch = 'main',
    build = ':TSUpdate',
    config = function()
      require('nvim-treesitter').install({
        -- always
        'c',
        'lua',
        'vim',
        'vimdoc',
        'query',

        -- additional
        'bash',
        'bibtex',
        'cmake',
        'cpp',
        'css',
        'dockerfile',
        'git_config',
        'git_rebase',
        'gitattributes',
        'gitcommit',
        'gitignore',
        'go',
        'html',
        'java',
        'javascript',
        'jsdoc',
        'json',
        'julia',
        'kotlin',
        'latex',
        'luadoc',
        'markdown',
        'markdown_inline',
        'python',
        'regex',
        'rust',
        'scheme',
        'scss',
        'sql',
        'toml',
        'tsx',
        'typescript',
        'yaml',
      })

      vim.api.nvim_create_autocmd('FileType', {
        callback = function(args)
          local filetype = args.match
          local lang = vim.treesitter.language.get_lang(filetype)
          if vim.treesitter.language.add(lang) then
            vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
            vim.bo.indentexpr = "v:lua.require('nvim-treesitter').indentexpr()"
            vim.treesitter.start()
          end
        end
      })
    end,
  },

  {
    'windwp/nvim-ts-autotag',
    config = function() require('nvim-ts-autotag').setup() end
  }

}
