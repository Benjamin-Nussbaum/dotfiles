local M = {
  "nvim-lualine/lualine.nvim",
  event = { "BufReadPost", "BufNewFile" },
}

function M.config()
  local diagnostics = {
    "diagnostics",
    sections = { "error", "warn" },
    colored = false, -- Displays diagnostics status in color if set to true.
    always_visible = true, -- Show diagnostics even if there are none.
  }

  require("lualine").setup({
    options = {
      theme = "tokyonight",
      component_separators = "|",
      section_separators = "",
      globalstatus = true,
      ignore_focus = { "NvimTree" },
    },
    sections = {
      lualine_a = {},
      lualine_b = { "branch", "diff" },
      lualine_c = { diagnostics },
      lualine_x = { "tabnine", "filetype" },
      lualine_y = { "progress" },
      lualine_z = {},
    },
    extensions = { "quickfix", "man", "fugitive", "oil" },
  })
end

return M
