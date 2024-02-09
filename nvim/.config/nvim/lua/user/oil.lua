local M = {
  "stevearc/oil.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  event = { "BufReadPost", "BufNewFile" },
}

function M.config()
  local oil = require("oil")

  oil.setup({
    skip_confirm_for_simple_edits = true,
    use_default_keymaps = false,
    keymaps = {
      ["g?"] = "actions.show_help",
      ["<CR>"] = "actions.select",
      ["l"] = "actions.select",
      -- ["<C-s>"] = "actions.select_vsplit",
      ["<C-s>"] = "actions.select_split",
      -- ["<C-h>"] = "actions.select_split",
      ["<C-v>"] = "actions.select_vsplit",
      ["<C-t>"] = "actions.select_tab",
      ["<C-p>"] = "actions.preview",
      ["<C-c>"] = "actions.close",
      ["q"] = "actions.close",
      -- ["<C-l>"] = "actions.refresh",
      ["r"] = "actions.refresh",
      -- ["-"] = "actions.parent",
      ["h"] = "actions.parent",
      ["_"] = "actions.open_cwd",
      ["`"] = "actions.cd",
      ["~"] = "actions.tcd",
      ["gs"] = "actions.change_sort",
      ["gx"] = "actions.open_external",
      -- ["g."] = "actions.toggle_hidden",
      ["gh"] = "actions.toggle_hidden",
      ["g\\"] = "actions.toggle_trash",
    },
    float = {
      max_height = 20,
      max_width = 60,
    },
  })

  vim.keymap.set("n", "-", oil.toggle_float, { desc = "Oil buffer" })
end

return M
