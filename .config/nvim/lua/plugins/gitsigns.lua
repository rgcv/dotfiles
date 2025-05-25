return {

  'lewis6991/gitsigns.nvim',
  event = { 'BufReadPre', 'BufNewFile' },
  opts = {
    signs = {
      add = { text = '▎' },
      change = { text = '▎' },
      delete = { text = '' },
      topdelete = { text = '' },
      changedelete = { text = '▎' },
      untracked = { text = '▎' },
    },
    current_line_blame = true,
    on_attach = function(buffer)
      local gs = require('gitsigns')
      local function map(mode, lhs, rhs, opts)
        opts = opts or {}
        opts.buffer = buffer
        vim.keymap.set(mode, lhs, rhs, opts)
      end

      -- Navigation
      map('n', ']c', function()
        if vim.wo.diff then
          vim.cmd.normal({ ']c', bang = true })
        else
          gs.nav_hunk('next')
        end
      end, { desc = 'Next change' })
      map('n', '[c', function()
        if vim.wo.diff then
          vim.cmd.normal({ '[c', bang = true })
        else
          gs.nav_hunk('prev')
        end
      end, { desc = 'Previous hunk' })

      -- Actions
      map('n', '<Leader>hs', gs.stage_hunk, { desc = 'Stage hunk' })
      map('v', '<Leader>hs', function()
        gs.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') })
      end, { desc = 'Stage hunk' })

      map('n', '<Leader>hr', gs.reset_hunk, { desc = 'Reset hunk' })
      map('v', '<Leader>hr', function()
        gs.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') })
      end, { desc = 'Reset hunk' })

      map('n', '<Leader>hS', gs.stage_buffer)
      map('n', '<Leader>hR', gs.reset_buffer)
      map('n', '<Leader>hp', gs.preview_hunk)
      map('n', '<Leader>hi', gs.preview_hunk_inline)

      map('n', '<Leader>hb', function()
        gs.blame_line({ full = true })
      end, { desc = 'Blame line' })

      map('n', '<Leader>hd', gs.diffthis, { desc = 'Diff this' })

      map('n', '<Leader>hD', function()
        gs.diffthis('~')
      end, { desc = 'Diff this' })

      map('n', '<Leader>hQ', function() gs.setqflist('all') end)
      map('n', '<Leader>hq', gs.setqflist)

      -- Toggles
      map('n', '<Leader>tb', gs.toggle_current_line_blame)
      map('n', '<Leader>tw', gs.toggle_word_diff)
    end
  },

}
