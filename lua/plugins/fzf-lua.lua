return {
  'ibhagwan/fzf-lua',

  dependencies = {
    {
      'nvim-tree/nvim-web-devicons',
      enabled = vim.g.have_nerd_font,
    },
  },

  ---@module "fzf-lua"
  ---@type fzf-lua.Config
  opts = {
    defaults = {
      formatter = 'path.filename_first',
      file_ignore_patterns = { '%.git/' },
    },

    grep = {
      search = '',
    },

    files = {
      hidden = true,
    },

    lsp = {
      references = {
        show_line = false,
        includeDeclaration = false,
      },
    },

    keymap = {
      builtin = {
        ['<C-s>'] = 'select-horizontal',
      },
    },
  },

  keys = {
    {
      '<leader>f',
      function()
        require('fzf-lua').files()
      end,
      desc = 'Search [F]iles',
    },
    {
      '<leader>sif',
      function()
        require('fzf-lua').files { fd_opts = '--no-ignore' }
      end,
      desc = '[S]earch not [I]gnored [F]iles',
    },
    {
      '<localleader>f',
      function()
        local cwd = nil
        local cwf = vim.fn.expand '%:p'
        if cwf ~= '' and vim.uv.fs_stat(cwf) ~= nil then
          cwd = vim.fn.expand '%:p:h'
        end
        if vim.bo.filetype == 'oil' then
          cwd = require('oil').get_current_dir()
        end
        if vim.bo.buftype == 'terminal' then
          local bufname = vim.api.nvim_buf_get_name(0)
          cwd = bufname:match '^term://(.-)/%d+:'
        end
        require('fzf-lua').files {
          cwd = cwd,
        }
      end,
      desc = 'Search [F]iles in current directory',
    },
    {
      '<leader>/',
      function()
        require('fzf-lua').live_grep { grep_open_files = true, rg_opts = '--column --line-number --no-heading --color=always --smart-case --fixed-strings' }
      end,
      desc = 'Search [/]',
    },
    {
      '<leader>si/',
      function()
        require('fzf-lua').live_grep {
          grep_open_files = true,
          rg_opts = '--column --line-number --no-heading --color=always --smart-case --fixed-strings --no-ignore',
        }
      end,
      desc = '[S]earch not [I]gnored [/]',
    },
    {
      '<localleader>/',
      function()
        local cwd = nil
        local cwf = vim.fn.expand '%:p'
        if cwf ~= '' and vim.uv.fs_stat(cwf) ~= nil then
          cwd = vim.fn.expand '%:p:h'
        end
        if vim.bo.filetype == 'oil' then
          cwd = require('oil').get_current_dir()
        end
        if vim.bo.buftype == 'terminal' then
          local bufname = vim.api.nvim_buf_get_name(0)
          cwd = bufname:match '^term://(.-)/%d+:'
        end
        require('fzf-lua').live_grep {
          cwd = cwd,
        }
      end,
      desc = 'Search [/] in current directory',
    },
    {
      '<leader>sw',
      function()
        require('fzf-lua').grep_cword()
      end,
      desc = 'Search current [W]ord',
    },
    {
      '<leader>sd',
      function()
        require('fzf-lua').diagnostics_document()
      end,
      desc = 'Search [D]iagnostics',
    },
    {
      '<leader>sr',
      function()
        require('fzf-lua').resume()
      end,
      desc = 'Search [R]esume',
    },
    {
      '<leader>s.',
      function()
        require('fzf-lua').oldfiles()
      end,
      desc = '[S]earch Recent Files',
    },

    {
      '<leader><leader>',
      function()
        require('fzf-lua').buffers()
      end,
      desc = '[ ] Find existing buffers',
    },
    {
      '<leader>,',
      function()
        require('fzf-lua').git_status()
      end,
      desc = 'Search changed Files using Git',
    },
    {
      '<leader>sn',
      function()
        require('fzf-lua').files { cwd = vim.fn.stdpath 'config' }
      end,
      desc = '[S]earch [N]eovim files',
    },
  },
}
