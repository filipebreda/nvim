-- [[ Setting options ]]
-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true

-- Set font family and size
vim.o.guifont = 'FiraMono Nerd Font:h12'

-- Set tabs
vim.bo.shiftwidth = 4
vim.bo.softtabstop = 4
vim.bo.expandtab = true
vim.bo.autoindent = true
vim.bo.smartindent = false
vim.bo.cindent = false

vim.opt.number = true
vim.opt.relativenumber = true

-- Enable mouse mode
vim.opt.mouse = 'a'

-- Don't show the mode, since it's already in the status line
vim.opt.showmode = false

-- Sync clipboard between OS and Neovim.
vim.opt.clipboard = 'unnamedplus'

-- Enable break indent to distinguish wrapped from new lines
vim.opt.breakindent = true

-- Save undo history
vim.opt.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn on by default
vim.opt.signcolumn = 'yes'

-- Decrease update time
vim.opt.updatetime = 250

-- Decrease mapped sequence wait time
-- Displays which-key popup sooner
vim.opt.timeoutlen = 300

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Preview substitutions live, as you type!
vim.opt.inccommand = 'split'

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 10

-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous [D]iagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next [D]iagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
vim.keymap.set('t', '<C-S-v>', '<C-\\><C-n>+pi', { desc = 'clipboard paste' })
vim.keymap.set({ 'i', 'c' }, '<C-S-v>', '<C-r>+', { desc = 'clipboard paste' })

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- Navigate through buffers faster
vim.keymap.set('n', '<C-x>', ':bd<CR>')

local function has_git_changes(filepath)
  if not filepath or filepath == '' then
    return false
  end

  if vim.fn.filereadable(filepath) == 0 then
    return false
  end

  local cmd = string.format(
    'git -C %s status --porcelain %s',
    vim.fn.shellescape(vim.fn.fnamemodify(filepath, ':h')),
    vim.fn.shellescape(vim.fn.fnamemodify(filepath, ':t'))
  )

  local result = vim.fn.system(cmd)

  -- If git command failed (not in a git repo), return false
  if vim.v.shell_error ~= 0 then
    return false
  end

  -- If there's any output, file has changes
  return result and result:match '%S' ~= nil
end

local function get_buffer_last_change_time(bufnr)
  local changedtick = vim.api.nvim_buf_get_changedtick(bufnr)
  return changedtick or 0
end

local function navigate_to_last_edited()
  local current_buf = vim.api.nvim_get_current_buf()
  local buffers = vim.api.nvim_list_bufs()
  print 'buffers'
  print(buffers)

  local latest_bufnr = nil
  local latest_change = 0
  local latest_name = ''

  for _, bufnr in ipairs(buffers) do
    print 'buffer nr'
    print(bufnr)
    if bufnr ~= current_buf and vim.api.nvim_buf_is_loaded(bufnr) then
      local filepath = vim.api.nvim_buf_get_name(bufnr)

      if filepath ~= '' and not filepath:match '^%w+://' then
        local has_changes = has_git_changes(filepath)

        if has_changes then
          local last_change = get_buffer_last_change_time(bufnr)
          print 'has changes'
          print(last_change)
          print(latest_change)

          if last_change > latest_change then
            latest_change = last_change
            latest_bufnr = bufnr
            latest_name = vim.fn.fnamemodify(filepath, ':t')
          end
        end
      end
    end
  end

  if not latest_bufnr then
    print 'No buffers with git changes found'
    return
  end

  vim.api.nvim_set_current_buf(latest_bufnr)
  print(string.format('Navigated to: %s', latest_name))
end

vim.keymap.set('n', '<C-p>', navigate_to_last_edited, { desc = 'Navigate to last edited buffer' })

vim.keymap.set('n', '<leader>bo', function()
  local current_buf = vim.api.nvim_get_current_buf()
  local buffers = vim.api.nvim_list_bufs()

  for _, buf in ipairs(buffers) do
    if buf ~= current_buf and vim.api.nvim_buf_is_loaded(buf) then
      vim.api.nvim_buf_delete(buf, {})
    end
  end
end, { desc = '[B]uffers [O]nly and close all others' })

-- Open terminal
vim.keymap.set('n', '<leader>t', vim.cmd.term, { desc = 'Open [T]erminal' })

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Open terminal with custom config
vim.api.nvim_create_autocmd('TermOpen', {
  group = vim.api.nvim_create_augroup('term-open', { clear = true }),
  callback = function()
    vim.cmd.startinsert()
  end,
})

vim.keymap.set('n', '<localleader>t', function()
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
  if cwd == nil then
    vim.notify 'Directory not found!'
    return
  end

  local root_dir = vim.fn.getcwd()
  vim.cmd('lcd ' .. cwd .. ' | term')
  vim.cmd('lcd ' .. root_dir)
end, { desc = 'Open [T]erminal in current directory' })

local function is_terminal(bufnr)
  return vim.bo[bufnr].buftype == 'terminal'
end

-- Toggle terminal
local function get_sorted_buffers()
  local buffers = vim.fn.getbufinfo { buflisted = 1 }
  table.sort(buffers, function(a, b)
    return a.lastused > b.lastused
  end)
  return buffers
end

local function toggle_terminal()
  local current_buf = vim.api.nvim_get_current_buf()
  if is_terminal(current_buf) then
    for _, buf in ipairs(get_sorted_buffers()) do
      if vim.api.nvim_buf_is_valid(buf.bufnr) and not is_terminal(buf.bufnr) then
        vim.api.nvim_set_current_buf(buf.bufnr)
        return
      end
    end
  else
    for _, buf in ipairs(get_sorted_buffers()) do
      if is_terminal(buf.bufnr) and vim.api.nvim_buf_is_valid(buf.bufnr) then
        vim.api.nvim_set_current_buf(buf.bufnr)
        vim.cmd.startinsert()
        return
      end
    end
    vim.cmd 'term'
  end
end

vim.keymap.set({ 'n', 'i', 't' }, '<C-space>', toggle_terminal)

-- [[ Custom functions ]]
-- Copy current file's path
vim.api.nvim_create_user_command('CpCwf', function()
  local cwf = vim.fn.expand '%:p'
  if cwf == '' or vim.uv.fs_stat(cwf) == nil then
    vim.notify 'File not found!'
    return
  end
  vim.fn.setreg('+', cwf)
  vim.notify('Copied "' .. cwf .. '" to the clipboard!')
end, {})

-- Copy current directory's path
vim.api.nvim_create_user_command('CpCwd', function()
  local cwd = nil
  local cwf = vim.fn.expand '%:p'
  if cwf ~= '' and vim.uv.fs_stat(cwf) ~= nil then
    cwd = vim.fn.expand '%:p:h'
  end
  if vim.bo.buftype == 'terminal' then
    local bufname = vim.api.nvim_buf_get_name(0)
    cwd = bufname:match '^term://(.-)/%d+:'
  end
  if vim.bo.filetype == 'oil' then
    cwd = require('oil').get_current_dir()
  end
  vim.fn.setreg('+', cwd)
  vim.notify('Copied "' .. cwd .. '" to the clipboard!')
end, {})

-- Auto refresh buffers on external changes
vim.opt.autoread = true
vim.api.nvim_create_autocmd({ 'FocusGained', 'BufEnter' }, {
  group = vim.api.nvim_create_augroup('AutoReadGroup', { clear = true }),
  callback = function()
    vim.cmd 'checktime'
  end,
})

-- Auto save
vim.api.nvim_create_autocmd({ 'InsertLeave', 'TextChanged' }, {
  callback = function()
    if vim.bo.buftype == '' and vim.api.nvim_buf_get_name(0) ~= '' and vim.bo.buflisted then
      vim.cmd 'silent! wa'
    end
  end,
})

-- Go to floating window
local function jump_to_floating_window()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if vim.api.nvim_win_get_config(win).relative ~= '' then -- Floating windows have a non-empty 'relative' config
      vim.api.nvim_set_current_win(win)
      break
    end
  end
end
vim.keymap.set('n', '<C-w>f', jump_to_floating_window, { desc = 'Go to floating window' })

-- Set window title
vim.api.nvim_create_augroup('SetTerminalTitle', { clear = true })

vim.api.nvim_create_autocmd('VimEnter', {
  group = 'SetTerminalTitle',
  callback = function()
    vim.opt.title = true
    vim.opt.titlestring = vim.fn.expand '%:p:h:t'
  end,
})
