local M = {
  "lervag/vimtex",
  event = "VeryLazy",
}

function M.config()
  vim.g.vimtex_view_method = "zathura"

  vim.o.foldmethod = "expr"
  vim.o.foldexpr = "vimtex#fold#level(v:lnum)"
  vim.o.foldtext = "vimtex#fold#text()"
  vim.o.foldlevel = 2
end

return M
