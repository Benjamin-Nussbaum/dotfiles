local M = {
  "echasnovski/mini.surround",
  event = "VeryLazy",
}

M.config = function()
  require("mini.surround").setup({
    mappings = {
      add = "gsa",
      delete = "gsd",
      find = "gsf",
      find_left = "gsF",
      highlight = "gsh",
      replace = "gsr",
      update_n_lines = "gsn",
    },
  })
end

return M
