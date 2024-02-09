local M = {
  "LunarVim/breadcrumbs.nvim",
  dependencies = {
    "SmiteshP/nvim-navic",
  },
  event = { "BufReadPost", "BufNewFile" },
}

function M.config()
  require("breadcrumbs").setup()
end

return M
