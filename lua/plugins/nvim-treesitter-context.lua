return {
  'nvim-treesitter/nvim-treesitter-context',
  dependencies = { 'nvim-treesitter/nvim-treesitter' },
  config = function()
    require('treesitter-context').setup {
      enable = true, -- Enable this plugin (can be set to false for debugging)
      throttle = true, -- Throttles plugin updates (improves performance)
      max_lines = 0, -- No limit on the number of lines the context window spans
      multiline_threshold = 1,
      -- patterns = { -- Match patterns for TS nodes
      --     default = {
      --         "class",
      --         "function",
      --         "method",
      --         "for",
      --         "while",
      --         "if",
      --         "switch",
      --         "case",
      --     },
      -- },
    }
  end,
}
