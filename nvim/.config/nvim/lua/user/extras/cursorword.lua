local M = {
  "echasnovski/mini.cursorword",
  event = "VeryLazy",
}

function M.config()
  require("mini.cursorword").setup({
    delay = 0,
  })

  vim.api.nvim_create_autocmd({ "FileType" }, {
    group = vim.api.nvim_create_augroup("cursorword_disable", {}),
    pattern = {
      "alpha",
      "DiffviewFiles",
      "dirvish",
      "DressingInput",
      "DressingSelect",
      "fugitive",
      "harpoon",
      "Jaq",
      "lazy",
      "lir",
      "mason",
      "minifiles",
      "NeogitCommitMessage",
      "NeogitStatus",
      "netrw",
      "NvimTree",
      "oil",
      "Outline",
      "qf",
      "spectre_panel",
      "TelescopePrompt",
      "toggleterm",
      "Trouble",
    },
    callback = function() vim.b.minicursorword_disable = true end,
  })
end

return M
