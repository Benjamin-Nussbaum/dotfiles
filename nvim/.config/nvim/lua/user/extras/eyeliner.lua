local M = {
  "jinh0/eyeliner.nvim",
  event = { "BufReadPost", "BufNewFile" },
}

function M.config()
  require("eyeliner").setup({
    highlight_on_key = true, -- show highlights only after keypress
    dim = true, -- dim all other characters if set to true (recommended!)
  })
end

return M
