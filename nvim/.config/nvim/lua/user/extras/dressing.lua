local M = {
  "stevearc/dressing.nvim",
  event = "VeryLazy",
}

function M.config() require("dressing").setup({}) end

return M
