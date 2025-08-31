return {
  "ruifm/gitlinker.nvim",
  dependencies = "nvim-lua/plenary.nvim",
  config = function()
    local gitlinker = require("gitlinker")
    local actions = require("gitlinker.actions")

    gitlinker.setup()

    -- Normal mode: copy link for current line
    vim.keymap.set("n", "<leader>gy", function()
      gitlinker.get_buf_range_url("n", { action_callback = actions.copy_to_clipboard })
    end, { desc = "Copy [G]it host [L]ink to current line" })
  end,
}
