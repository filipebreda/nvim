-- Heavily inspired from before.nvim by bloznelis

local M = {}

M.edit_locations = {}
M.file_to_index = {}

M.max_entries = nil

local function within_bounds(bufnr, line)
  local total_lines = vim.api.nvim_buf_line_count(bufnr)
  return line > 0 and line < total_lines + 1
end

local function bufvalid(bufnr)
  return vim.api.nvim_buf_is_loaded(bufnr) and vim.api.nvim_buf_is_valid(bufnr)
end

local function same_file(this_location, that_location)
  return this_location.file == that_location.file
end

local function is_regular_buffer(bufnr)
  return vim.bo[bufnr].buftype == ''
end

local function should_remove(location)
  return not bufvalid(location.bufnr) or not within_bounds(location.bufnr, location.line) or not is_regular_buffer(location.bufnr)
end

local function assign_location(new_location)
  if not is_regular_buffer(new_location.bufnr) or not within_bounds(new_location.bufnr, new_location.line) then
    return
  end

  local file_path = new_location.file
  local existing_index = M.file_to_index[file_path]
  if existing_index then
    M.edit_locations[existing_index] = new_location
  else
    table.insert(M.edit_locations, new_location)
    M.file_to_index[file_path] = #M.edit_locations
    if #M.edit_locations > M.max_entries then
      local removed_location = table.remove(M.edit_locations, 1)
      M.file_to_index[removed_location.file] = nil
      for file, index in pairs(M.file_to_index) do
        M.file_to_index[file] = index - 1
      end
    end
  end
end

local function find_backwards_jump(currentLocation)
  for i = #M.edit_locations, 1, -1 do
    local location = M.edit_locations[i]
    if location and not bufvalid(location.bufnr) then
      vim.cmd.edit(location.file)
      local new_bufnr = vim.api.nvim_get_current_buf()
      location['bufnr'] = new_bufnr
      M.edit_locations[i] = location
    end
    if location and should_remove(location) then
      M.file_to_index[location.file] = nil
      table.remove(M.edit_locations, i)
    elseif location and not same_file(currentLocation, location) then
      return location
    end
  end

  if #M.edit_locations > 0 then
    local fallback_location = M.edit_locations[#M.edit_locations]
    if fallback_location and should_remove(fallback_location) then
      M.file_to_index[fallback_location.file] = nil
      table.remove(M.edit_locations, #M.edit_locations)
    else
      return fallback_location
    end
  else
    print 'No other edited files available.'
  end
end

function M.track_edit()
  local bufnr = vim.api.nvim_get_current_buf()
  local file = vim.api.nvim_buf_get_name(bufnr)
  local pos = vim.api.nvim_win_get_cursor(0)
  local location = { bufnr = bufnr, line = pos[1], col = pos[2], file = file }

  assign_location(location)
end

function M.jump()
  if #M.edit_locations > 0 then
    local bufnr = vim.api.nvim_get_current_buf()
    local file = vim.api.nvim_buf_get_name(bufnr)
    local pos = vim.api.nvim_win_get_cursor(0)
    local current = { bufnr = bufnr, line = pos[1], col = pos[2], file = file }

    local new_location = find_backwards_jump(current)

    if new_location then
      vim.api.nvim_win_set_buf(0, new_location.bufnr)
      vim.api.nvim_win_set_cursor(0, { new_location.line, new_location.col })
    end
  else
    print 'No edit locations stored.'
  end
end

M.defaults = {
  history_size = 2,
}

function M.setup(opts)
  opts = vim.tbl_deep_extend('force', M.defaults, opts or {})

  M.max_entries = opts.history_size

  vim.api.nvim_create_autocmd({ 'TextChanged', 'InsertEnter' }, {
    pattern = '*',
    callback = function()
      M.track_edit()
    end,
  })
end

return M
