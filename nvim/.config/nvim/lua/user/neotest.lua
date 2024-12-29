local M = {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-neotest/nvim-nio",
    "nvim-treesitter/nvim-treesitter",
    -- general tests
    "vim-test/vim-test",
    "nvim-neotest/neotest-vim-test",
    -- language specific tests
    "marilari88/neotest-vitest",
    "nvim-neotest/neotest-python",
    "nvim-neotest/neotest-plenary",
    "rouge8/neotest-rust",
    "rcasia/neotest-bash",
  },
  event = "VeryLazy",
}

function M.config()
  local function nmap(lhs, rhs, desc)
    local opts = { silent = true, desc = desc or "" }
    local mode = "n"
    vim.keymap.set(mode, lhs, rhs, opts)
  end

  nmap("<leader>td", function() require("neotest").run.run({ strategy = "dap" }) end, "Debug Test")
  nmap("<leader>tf", function() require("neotest").run.run(vim.fn.expand("%")) end, "Test File")
  nmap("<leader>tt", function() require("neotest").run.run() end, "Test Nearest")
  nmap("<leader>ts", function() require("neotest").run.stop() end, "Test Stop")
  nmap("<leader>ta", function() require("neotest").run.attach() end, "Attach Test")

  local install_ok, wk = pcall(require, "which-key")
  if install_ok then
    wk.add({ { "<leader>t", group = "[T]est" } })
  end

  ---@diagnostic disable: missing-fields
  require("neotest").setup({
    adapters = {
      require("neotest-python")({
        dap = { justMyCode = false },
      }),
      require("neotest-vitest"),
      require("neotest-rust"),
      require("neotest-vim-test")({
        ignore_file_types = { "python", "vim", "lua", "javascript", "typescript" },
      }),
    },
  })
end

return M
