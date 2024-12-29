local M = {
  "MeanderingProgrammer/markdown.nvim",
  main = "render-markdown",
  event = "BufWinEnter *.md",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons",
  },
}

function M.config()
  local rm = require("render-markdown")
  rm.setup({})
  rm.enable()
end

return M
