local M = {
  "f3fora/nvim-texlabconfig",
  ft = { "tex", "bib" }, -- Lazy-load on filetype
  build = "go build",
  -- build = 'go build -o ~/.bin/' if e.g. ~/.bin/ is in $PATH
}

function M.config()
  require("texlabconfig").setup()
end

return M
