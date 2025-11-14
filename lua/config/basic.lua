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

-- Improve native search (e.g. :find, :grep, etc.)
vim.opt.path:append '**'
vim.opt.wildignore:append {
  '*.zip',
  '*.tar.gz',
  '*.tar.bz2',
  '*.pyc',
  '*/dist/*',
  '*/build/*',
  '*/.git/*',
  '*/.venv/*',
  '*/venv/*',
  '*/__pycache__/*',
  '*/node_modules/*',
}
vim.opt.wildmenu = true
vim.opt.wildmode = { 'longest:full', 'full' }

-- Set tabs
-- handled by vim-sleuth
-- vim.bo.shiftwidth = 4
-- vim.bo.softtabstop = 4
-- vim.bo.expandtab = true
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

-- Fold based on indent level
vim.opt.foldenable = true
vim.opt.foldmethod = 'indent'
vim.opt.foldlevel = 99

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
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
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
    require('oil').open()
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
-- Copy current file's absolute path
vim.api.nvim_create_user_command('YankPathAbsolute', function()
  local cwp = vim.fn.expand '%:p'
  if vim.bo.buftype == 'terminal' then
    local bufname = vim.api.nvim_buf_get_name(0)
    cwp = bufname:match '^term://(.-)/%d+:'
  end
  if vim.bo.filetype == 'oil' then
    local dir = require('oil').get_current_dir()
    if dir == nil then
      vim.notify 'Directory not found!'
      return
    end
    cwp = dir
  end
  vim.fn.setreg('+', cwp)
  vim.notify('Copied "' .. cwp .. '" to the clipboard!')
end, {})

-- Copy current file's relative path
vim.api.nvim_create_user_command('YankPath', function()
  local cwp = vim.fn.fnamemodify(vim.fn.expand '%:p', ':.')
  if vim.bo.buftype == 'terminal' then
    local bufname = vim.api.nvim_buf_get_name(0)
    local dir = bufname:match '^term://(.-)/%d+:'
    cwp = vim.fn.fnamemodify(dir, ':.')
    if cwp == '' then
      vim.notify 'At root directory, nothing to yank!'
      return
    end
  end
  if vim.bo.filetype == 'oil' then
    local oil = require 'oil'
    local dir = oil.get_current_dir()
    if dir == nil then
      vim.notify 'Directory not found!'
      return
    end
    cwp = vim.fn.fnamemodify(dir, ':.')
    if cwp == '' then
      vim.notify 'At root directory, nothing to yank!'
      return
    end
  end
  vim.fn.setreg('+', cwp)
  vim.notify('Copied "' .. cwp .. '" to the clipboard!')
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

-- Notes file
local notes_file = vim.fn.expand '~/notes.txt'
vim.keymap.set('n', '<leader>n', function()
  vim.cmd('edit ' .. notes_file)
end, { desc = 'Open notes' })

-- Set window title
local set_title_group = vim.api.nvim_create_augroup('SetTerminalTitle', { clear = true })

local function set_title()
  local cwd = vim.loop.cwd() or vim.fn.getcwd()
  if not cwd or cwd == '' then
    return
  end

  vim.opt.title = true
  vim.opt.titlestring = vim.fn.fnamemodify(cwd, ':t')
end

vim.api.nvim_create_autocmd({ 'VimEnter', 'DirChanged' }, {
  group = set_title_group,
  callback = set_title,
})
