local M = {
  "stevearc/conform.nvim",
  event = { "BufReadPre", "BufNewFile" },
}

function M.config()
  local conform = require("conform")

  conform.setup({
    formatters_by_ft = {
      -- css = { "prettierd" },
      -- html = { "prettierd" },
      -- json = { "prettierd" },
      -- yaml = { "prettierd" },
      markdown = { "prettierd" },
      lua = { "stylua" },
      -- sh = { "shfmt" },
      -- python = { "ruff_fix", "ruff_format", "ruff_organize_imports" },
      -- latex = { "latexindent" },
    },
    format_on_save = {
      lsp_format = "fallback",
      timeout_ms = 500,
    },
  })

  vim.keymap.set({ "n", "i", "x" }, "<F3>", function()
    conform.format({
      lsp_format = "fallback",
      timeout_ms = 1000,
    })
  end, { desc = "Format file or range (in visual mode)" })
end

return M
