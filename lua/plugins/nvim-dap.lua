return {
  {
    'mfussenegger/nvim-dap',
    dependencies = {
      'theHamsta/nvim-dap-virtual-text',
      'nvim-neotest/nvim-nio',
      'jay-babu/mason-nvim-dap.nvim', -- installs debug adapters
      'williamboman/mason.nvim',
    },
    config = function()
      local dap = require 'dap'

      require('mason').setup()
      require('mason-nvim-dap').setup {
        ensure_installed = { 'python' }, -- installs debugpy & node
        automatic_installation = true,
      }

      dap.adapters.debugpy = {
        type = 'server',
        host = '127.0.0.1',
        port = 3233,
      }

      vim.g.python3_host_prog = vim.g.python3_host_prog or '/usr/bin/python3'
      dap.configurations.python = {
        {
          name = 'Local Python Attach',
          type = 'debugpy',
          request = 'attach',
          connect = {
            host = '127.0.0.1',
            port = 3233,
          },
          justMyCode = false,
          pythonPath = vim.g.python3_host_prog,
        },
      }

      vim.keymap.set('n', '<F5>', dap.continue)
      vim.keymap.set('n', '<F6>', dap.step_over)
      vim.keymap.set('n', '<F7>', dap.step_into)
      vim.keymap.set('n', '<F8>', dap.step_out)
      vim.keymap.set('n', '<Leader>b', dap.toggle_breakpoint)
      vim.keymap.set('n', '<Leader>B', function()
        dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
      end)
    end,
  },
}
