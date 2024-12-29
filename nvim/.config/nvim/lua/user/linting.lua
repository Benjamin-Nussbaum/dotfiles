local M = {
  "mfussenegger/nvim-lint",
  event = { "BufReadPre", "BufNewFile" },
}

function M.config()
  local lint = require("lint")

  lint.linters_by_ft = {
    lua = { "selene" },
    -- python = { "mypy" },
    -- markdown = { "markdownlint-cli2" },
    latex = { "chktex" },
  }

  vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
    group = vim.api.nvim_create_augroup("lint", { clear = true }),
    -- callback = lint.try_lint,
    callback = function()
      lint.try_lint()
    end,
  })

  -- vim.keymap.set("n", "<leader>l", function()
  --   lint.try_lint()
  -- end, { desc = "Trigger linting for current file" })
end

return M
