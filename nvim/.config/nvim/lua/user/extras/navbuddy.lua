local M = {
  "SmiteshP/nvim-navbuddy",
  dependencies = {
    "SmiteshP/nvim-navic",
    "MunifTanjim/nui.nvim",
  },
  event = "VeryLazy",
}

function M.config()
  local navbuddy = require("nvim-navbuddy")

  navbuddy.setup({
    window = {
      border = "rounded",
    },
    icons = require("user.icons").kind,
    lsp = { auto_attach = true },
  })

  vim.keymap.set("n", "<leader>o", navbuddy.open, { silent = true, desc = "Navbuddy" })
end

return M
