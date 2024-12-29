local M = {
  "theprimeagen/harpoon",
  branch = "harpoon2",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
  },
  event = "VeryLazy",
}

function M.add_file()
  require("harpoon"):list():append()
  vim.notify("⇁ added file")
end

function M.config()
  local harpoon = require("harpoon")
  harpoon:setup({
    settings = {
      save_on_toggle = true,
    },
  })

  -- basic telescope configuration
  local conf = require("telescope.config").values
  local function toggle_telescope(harpoon_files)
    local file_paths = {}
    for _, item in ipairs(harpoon_files.items) do
      table.insert(file_paths, item.value)
    end

    -- Seems bugged at the moment...
    local function delete()
      harpoon:list():remove(require("telescope.actions.state").get_selected_entry().value)
    end
    require("telescope.pickers")
      .new(require("telescope.themes").get_dropdown({
        prompt_title = "Harpoon",
        finder = require("telescope.finders").new_table({ results = file_paths }),
        previewer = false,
        initial_mode = "normal",
        sorter = conf.generic_sorter({}),
        path_display = require("user.telescope").filenameFirst,
        mappings = {
          i = {
            ["<C-d>"] = delete,
          },
          n = {
            ["dd"] = delete,
          },
        },
      }))
      :find()
  end

  local function nmap(lhs, rhs, desc)
    local opts = { silent = true, desc = desc or "" }
    local mode = "n"
    vim.keymap.set(mode, lhs, rhs, opts)
  end

  nmap("<leader>ha", M.add_file, "[A]dd file")
  nmap("<leader>hl", function()
    harpoon.ui:toggle_quick_menu(harpoon:list())
  end, "[H]arpoon [L]ist")

  -- nmap("<tab>", function() toggle_telescope(harpoon:list()) end, "[H]arpoon list (telescope)")

  nmap("<C-h>", function()
    harpoon:list():select(1)
  end, "Harpoon 1")
  nmap("<C-j>", function()
    harpoon:list():select(2)
  end, "Harpoon 2")
  nmap("<C-k>", function()
    harpoon:list():select(3)
  end, "Harpoon 3")
  nmap("<C-l>", function()
    harpoon:list():select(4)
  end, "Harpoon 4")

  nmap("<C-tab>", function()
    harpoon:list():next({ ui_nav_wrap = true })
  end)
  nmap("<C-S-tab>", function()
    harpoon:list():prev({ ui_nav_wrap = true })
  end)

  local require_ok, wk = pcall(require, "which-key")
  if require_ok then
    wk.add({ { "<leader>h", group = "[H]arpoon" } })
  end
end

return M
