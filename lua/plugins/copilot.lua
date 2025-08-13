return {
  'github/copilot.vim',
  setup = function()
    vim.g.copilot_filetypes = {
      ['copilot-chat'] = false, -- Disable for all file types by default
      ['oil'] = false, -- Disable for all file types by default
    }
  end,
}
