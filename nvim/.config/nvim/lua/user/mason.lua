local M = {
  "williamboman/mason-lspconfig.nvim",
  dependencies = {
    "williamboman/mason.nvim",
    "nvim-lua/plenary.nvim",
  },
  event = { "BufReadPre", "BufNewFile" },
}

function M.config()
  require("mason").setup({
    ensure_installed = {
      "lua_ls",
      "stylua",
      "luacheck",
      "pyright",
      "ruff_lsp",
      "ruff",
      "reorder-python-imports",
    },
  })
  require("mason-lspconfig").setup({})
end

return M
