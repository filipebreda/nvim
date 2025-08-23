return {
  'folke/which-key.nvim',
  event = 'VimEnter', -- Sets the loading event to 'VimEnter'
  opts = {
    icons = {
      mappings = false,
    },

    -- Document existing key chains
    spec = {
      { '<leader>s', group = '[S]earch' },
      { '<localleader>s', group = '[S]earch' },
      { '<leader>w', group = '[W]orkspace' },
      { '<leader>g', group = '[G]it', mode = { 'n', 'v' } },
      { '<leader>c', group = '[C]opilot', mode = { 'n', 'v' } },
      { '<leader>b', group = '[B]uffers', mode = { 'n', 'v' } },
    },
  },
}
