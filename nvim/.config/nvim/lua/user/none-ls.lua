local M = {
  "nvimtools/none-ls.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  event = { "BufReadPre", "BufNewFile" },
}

function M.config()
  local null_ls = require("null-ls")

  local formatting = null_ls.builtins.formatting
  local diagnostics = null_ls.builtins.diagnostics
  local code_actions = null_ls.builtins.code_actions

  null_ls.setup({
    debug = false,
    sources = {
      code_actions.gitsigns,
      code_actions.refactoring,

      diagnostics.luacheck,
      formatting.stylua,

      diagnostics.ruff,
      formatting.ruff,
      formatting.reorder_python_imports,

      null_ls.builtins.completion.spell,
    },
    on_attach = function(client, bufnr)
      if client.supports_method("textDocument/formatting") then
        vim.api.nvim_create_autocmd("BufWritePre", {
          group = vim.api.nvim_create_augroup("LspFormatting", {}),
          buffer = bufnr,
          callback = function() vim.lsp.buf.format() end,
        })
      end
    end,
  })
end

return M
