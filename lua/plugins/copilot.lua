return {
  {
    'CopilotC-Nvim/CopilotChat.nvim',
    dependencies = {
      { 'github/copilot.vim' },
      { 'nvim-lua/plenary.nvim', branch = 'master' },
    },
    build = 'make tiktoken',
    opts = {
      prompts = {
        Rename = {
          prompt = 'Please rename the variables correctly in given selection based on context',
          mapping = '<leader>cn',
          selection = function(source)
            local select = require('CopilotChat.select')
            return select.visual(source)
          end,
        },
      },
    },
    keys = {
      { '<leader>cc', ':CopilotChat<CR>', mode = 'n', desc = '[C]opilot [C]hat' },
      { '<leader>cd', ':CopilotChatDoc<CR>', mode = 'v', desc = '[C]opilot generate [D]ocstring' },
      { '<leader>ce', ':CopilotChatExplain<CR>', mode = 'v', desc = '[C]opilot [E]xplain' },
      { '<leader>co', ':CopilotChatOptimize<CR>', mode = 'v', desc = '[C]opilot [O]ptimize' },
      { '<leader>cr', ':CopilotChatReview<CR>', mode = 'v', desc = '[C]opilot [R]eview' },
      { '<leader>ct', ':CopilotChatTests<CR>', mode = 'v', desc = '[C]opilot generate [T]ests' },
      { '<leader>cf', ':CopilotChatFix<CR>', mode = 'v', desc = '[C]opilot [F]ix code' },
    },
    lazy = false,
  },
}
