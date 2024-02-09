local M = {
  "folke/todo-comments.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  event = { "BufReadPre", "BufNewFile" },
}

function M.config()
  local todo_comments = require("todo-comments")

  vim.keymap.set("n", "]t", todo_comments.jump_next, { desc = "Next todo comment" })
  vim.keymap.set("n", "[t", todo_comments.jump_prev, { desc = "Previous todo comment" })

  todo_comments.setup({})
end

return M
