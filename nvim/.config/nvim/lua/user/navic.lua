local M = {
  "SmiteshP/nvim-navic",
  event = { "BufReadPost", "BufNewFile" },
}

function M.config()
  local icons = require("user.icons")

  require("nvim-navic").setup({
    -- icons = icons.kind,
    lsp = {
      auto_attach = true,
    },
    highlight = true,
    separator = " " .. icons.ui.ChevronRight .. " ",
    click = true,
  })
end

return M
