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
        ensure_installed = { 'python' },
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

      vim.keymap.set({'n', 'i'}, '<F2>', dap.toggle_breakpoint)
      vim.keymap.set({'n', 'i'}, '<F3>', dap.run_to_cursor)
      vim.keymap.set({'n', 'i'}, '<F4>', dap.repl.toggle)
      vim.keymap.set({'n', 'i'}, '<F5>', dap.continue)
      vim.keymap.set({'n', 'i'}, '<F6>', dap.terminate)
      vim.keymap.set({'n', 'i'}, '<F7>', dap.clear_breakpoints)
      vim.keymap.set({'n', 'i'}, '<F8>', dap.up)
      vim.keymap.set({'n', 'i'}, '<F9>', dap.down)
    end,
  },
}
