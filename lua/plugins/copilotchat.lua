return {
  {
    'CopilotC-Nvim/CopilotChat.nvim',
    dependencies = {
      { 'nvim-lua/plenary.nvim', branch = 'master' },
      'github/copilot.vim',
    },
    build = 'make tiktoken',
    cmd = {
      'CopilotChat',
      'CopilotChatReview',
      'CopilotChatExplain',
      'CopilotChatDoc',
      'CopilotChatFix',
    },
    keys = {
      { '<leader>cc', '<cmd>CopilotChat<cr>', desc = '[C]opilot Chat' },
      { '<leader>cr', '<cmd>CopilotChatReview<cr>', desc = '[C]opilot [R]eview buffer' },
      { '<leader>cd', '<cmd>CopilotChatDoc<cr>', mode = 'v', desc = '[C]opilot generate [D]ocstring' },
      { '<leader>ce', '<cmd>CopilotChatExplain<cr>', mode = 'v', desc = '[C]opilot [E]xplain code' },
      { '<leader>cf', '<cmd>CopilotChatFix<cr>', mode = 'v', desc = '[C]opilot [F]ix code' },
    },
  },
}
