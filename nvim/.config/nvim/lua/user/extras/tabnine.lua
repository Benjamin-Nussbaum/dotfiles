local M = {
  "codota/tabnine-nvim",
  build = "./dl_binaries.sh",
  event = "InsertEnter",
  -- "tzachar/cmp-tabnine",
  -- event = "InsertEnter",
  -- build = "./install.sh",
  -- dependencies = { "codota/tabnine-nvim", build = "./dl_binaries.sh" },
}

function M.config()
  -- require("cmp_tabnine.config"):setup({
  --   max_lines = 1000,
  --   max_num_results = 20,
  --   sort = true,
  --   run_on_every_keystroke = true,
  --   snippet_placeholder = "..",
  --   ignored_file_types = {
  --     -- default is not to ignore
  --     -- uncomment to ignore in lua:
  --     -- lua = true
  --   },
  --   show_prediction_strength = false,
  --   min_percent = 0,
  -- })
  require("tabnine").setup({
    disable_auto_comment = true,
    accept_keymap = "<C-space>",
    dismiss_keymap = "<C-]>",
    debounce_ms = 800,
    suggestion_color = { gui = "#808080", cterm = 244 },
    exclude_filetypes = { "TelescopePrompt", "NvimTree" },
    log_file_path = nil, -- absolute path to Tabnine log file
  })
end

return M
