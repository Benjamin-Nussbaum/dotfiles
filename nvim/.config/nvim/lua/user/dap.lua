local M = {
  "mfussenegger/nvim-dap",
  event = "VeryLazy",
  dependencies = {
    {
      "rcarriga/nvim-dap-ui",
      "mfussenegger/nvim-dap-python",
      "theHamsta/nvim-dap-virtual-text",
      "nvim-telescope/telescope-dap.nvim",
    },
  },
}

function M.config()
  local function nmap(lhs, rhs, desc, opts)
    local defaults = { silent = true, desc = desc or "" }
    opts = vim.tbl_deep_extend("force", defaults, opts or {})
    vim.keymap.set("n", lhs, rhs, opts)
  end

  local dap = require("dap")
  nmap("<leader>db", dap.step_back, "Step Back")
  nmap("<leader>dc", dap.continue, "Continue")
  nmap("<leader>dC", dap.run_to_cursor, "Run To Cursor")
  nmap("<leader>dd", dap.disconnect, "Disconnect")
  nmap("<leader>dg", dap.session, "Get Session")
  nmap("<leader>di", dap.step_into, "Step Into")
  nmap("<leader>do", dap.step_over, "Step Over")
  nmap("<leader>dp", dap.pause, "Pause")
  nmap("<leader>dq", dap.close, "Quit")
  nmap("<leader>dr", dap.repl.toggle, "Toggle Repl")
  nmap("<leader>ds", dap.continue, "Start")
  nmap("<leader>dt", dap.toggle_breakpoint, "Toggle Breakpoint")
  nmap("<leader>du", dap.step_out, "Step Out")
  nmap("<leader>dU", function()
    require("dapui").toggle({ reset = true })
  end, "Toggle UI")

  local install_ok, wk = pcall(require, "which-key")
  if install_ok then
    wk.add({ { "<leader>d", group = "[D]AP" } })
  end
end

return M
