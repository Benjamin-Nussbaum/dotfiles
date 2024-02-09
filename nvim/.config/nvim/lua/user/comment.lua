local M = {
  "numToStr/Comment.nvim",
  dependencies = {
    {
      "JoosepAlviste/nvim-ts-context-commentstring",
      event = "VeryLazy",
    },
  },
  event = { "BufReadPost", "BufNewFile" },
}

function M.config()
  local api = require("Comment.api")

  local function map(mode, lhs, rhs, desc, opts)
    local defaults = { silent = true, desc = desc or "" }
    opts = vim.tbl_deep_extend("force", defaults, opts or {})
    vim.keymap.set(mode, lhs, rhs, opts)
  end

  -- See https://github.com/numToStr/Comment.nvim/blob/master/lua/Comment/api.lua
  map("n", "<C-/>", api.toggle.linewise.current, "Comment")
  map("v", "<C-/>", function()
    local esc = vim.api.nvim_replace_termcodes("<ESC>", true, false, true)
    vim.api.nvim_feedkeys(esc, "nx", false)
    api.locked("toggle.linewise")(vim.fn.visualmode())
  end, "Comment lines")

  vim.g.skip_ts_context_commentstring_module = true
  ---@diagnostic disable: missing-fields
  require("ts_context_commentstring").setup({
    enable_autocmd = false,
  })

  require("Comment").setup({
    pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
  })
end

return M
