local M = {}

M.latest_location = nil
M.previous_location = nil

local function is_regular_buffer(bufnr)
  return vim.bo[bufnr].buftype == ''
end

local function bufvalid(bufnr)
  return vim.api.nvim_buf_is_loaded(bufnr) and vim.api.nvim_buf_is_valid(bufnr)
end

local function within_bounds(bufnr, line)
  local total_lines = vim.api.nvim_buf_line_count(bufnr)
  return line > 0 and line < total_lines + 1
end

local function bufbroken(location)
  return not bufvalid(location.bufnr) or not within_bounds(location.bufnr, location.line) or not is_regular_buffer(location.bufnr)
end

function M.update()
  local bufnr = vim.api.nvim_get_current_buf()
  local file = vim.api.nvim_buf_get_name(bufnr)
  local pos = vim.api.nvim_win_get_cursor(0)
  local location = { bufnr = bufnr, file = file, line = pos[1], col = pos[2] }

  if not is_regular_buffer(location.bufnr) or not within_bounds(location.bufnr, location.line) then
    return
  end

  if M.latest_location and M.latest_location.file ~= location.file then
    M.previous_location = M.latest_location
  end

  M.latest_location = location
end

local function sync(location)
  if not location then
    return nil
  end

  if not bufvalid(location.bufnr) then
    vim.cmd.edit(location.file)
    local new_bufnr = vim.api.nvim_get_current_buf()
    location['bufnr'] = new_bufnr
  end

  if bufbroken(location) then
    return nil
  end

  return location
end

local function find_jump(curr_location)
  M.latest_location = sync(M.latest_location)
  M.previous_location = sync(M.previous_location)

  if not M.latest_location and M.previous_location then
    M.latest_location = M.previous_location
    M.previous_location = nil
  end

  if M.latest_location and M.latest_location.file ~= curr_location.file then
    return M.latest_location
  end

  if M.previous_location then
    return M.previous_location
  end
end

function M.jump()
  if not M.latest_location then
    vim.notify('No edit locations stored.', vim.log.levels.WARN)
    return nil
  end

  local bufnr = vim.api.nvim_get_current_buf()
  local file = vim.api.nvim_buf_get_name(bufnr)
  local pos = vim.api.nvim_win_get_cursor(0)
  local curr_location = { bufnr = bufnr, line = pos[1], col = pos[2], file = file }

  local targ_location = find_jump(curr_location)

  if not targ_location then
    vim.notify('No edit locations available.', vim.log.levels.WARN)
    return nil
  end

  vim.api.nvim_win_set_buf(0, targ_location.bufnr)
  vim.api.nvim_win_set_cursor(0, { targ_location.line, targ_location.col })
end

function M.setup()
  vim.api.nvim_create_autocmd({ 'TextChanged', 'InsertEnter' }, {
    pattern = '*',
    callback = function()
      M.update()
    end,
  })
end

return M
