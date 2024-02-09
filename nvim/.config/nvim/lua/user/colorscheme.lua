local M = {
  "folke/tokyonight.nvim",
  lazy = false,
  priority = 1000,
  opts = {
    styles = {
      keywords = { italic = false },
    },
  },
}

function M.config() vim.cmd.colorscheme("tokyonight") end

return M
