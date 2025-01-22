local pickers = require 'telescope.pickers'
local finders = require 'telescope.finders'
local make_entry = require 'telescope.make_entry'
local conf = require('telescope.config').values

local M = {}

local live_multigrep = function(opts)
  opts = opts or {}
  opts.cwd = opts.cwd or vim.uv.cwd()

  local finder = finders.new_async_job {
    command_generator = function(prompt)
      if not prompt or prompt == '' then
        return nil
      end

      local pieces = vim.split(prompt, '  ')
      local args = { 'rg' }
      if pieces[1] then
        table.insert(args, '-e')
        table.insert(args, pieces[1])
      end

      if pieces[2] then
        table.insert(args, '-g')
        table.insert(args, pieces[2])
      end

      return vim
        .iter({
          args,
          { '--color=never', '--no-heading', '--with-filename', '--line-number', '--column', '--smart-case', '--hidden' },
        })
        :flatten()
        :totable()
    end,
    entry_maker = make_entry.gen_from_vimgrep(opts),
    cwd = opts.cwd,
  }

  pickers
    .new(opts, {
      debounce = 100,
      prompt_title = 'Live Grep',
      finder = finder,
      previewer = conf.grep_previewer(opts),
      sorter = require('telescope.sorters').empty(),
    })
    :find()
end

M.setup = function()
  vim.keymap.set('n', '<leader>sg', live_multigrep, { desc = '[S]earch by [G]rep' })
  vim.keymap.set('n', '<localleader>sg', function()
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

    live_multigrep {
      cwd = cwd,
    }
  end, { desc = '[S]earch by [G]rep in current directory' })
end

return M
