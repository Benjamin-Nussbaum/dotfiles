local M = {
  "lukas-reineke/indent-blankline.nvim",
  event = "VeryLazy",
}

function M.config() require("ibl").setup({}) end

return M
