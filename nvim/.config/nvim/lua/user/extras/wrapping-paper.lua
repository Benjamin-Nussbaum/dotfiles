local M = {
  "benlubas/wrapping-paper.nvim",
  dependencies = {
    "MunifTanjim/nui.nvim",
  },
  event = "VeryLazy",
}

function M.config()
  local wp = require("wrapping-paper")
  vim.keymap.set("n", "gww", wp.wrap_line, { desc = "fake wrap current line" })
end

return M
