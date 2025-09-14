return {
  'sindrets/diffview.nvim',

  keys = {
    { '<leader>gd', ':DiffviewOpen<CR>', desc = '[G]it [D]iffview' },
    { '<leader>gD', ':DiffviewClose<CR>', desc = '[G]it close [D]iffview' },
    { '<leader>gf', ':DiffviewFileHistory %<CR>', desc = '[G]it file [F]ile history' },
    { '<leader>gF', ':DiffviewFileHistory<CR>', desc = '[G]it [F]ile history' },
  },
}
