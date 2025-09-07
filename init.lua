-- Set custom pre load project config
local project_pre_config = vim.fn.getcwd() .. '/.nvim.pre.lua'
if vim.fn.filereadable(project_pre_config) == 1 then
  dofile(project_pre_config)
end

require 'config.lazy'

-- Set custom post load project config
local project_post_config = vim.fn.getcwd() .. '/.nvim.post.lua'
if vim.fn.filereadable(project_post_config) == 1 then
  dofile(project_post_config)
end
