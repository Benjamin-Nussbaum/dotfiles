local M = {
  "0x100101/lab.nvim",
  build = "cd js && npm ci",
  cmd = "Lab",
  event = "VeryLazy",
}

function M.config()
  require("lab").setup({
    code_runner = {
      enabled = true,
    },
    quick_data = {
      enabled = false,
    },
  })

  local opts = { silent = true }
  vim.keymap.set("n", "<m-4>", ":Lab code run<cr>", opts)
  vim.keymap.set("n", "<m-5>", ":Lab code stop<cr>", opts)
  vim.keymap.set("n", "<m-6>", ":Lab code panel<cr>", opts)
end

return M
