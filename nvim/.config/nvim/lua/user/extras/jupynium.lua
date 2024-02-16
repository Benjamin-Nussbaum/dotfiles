local M = {
  "kiyoon/jupynium.nvim",
  build = "conda run --no-capture-output -n jupynium pip install .",
  cmd = "JupyniumStartAndAttachToServerInTerminal",
  event = "BufWinEnter *.ju.py",
}

function M.config()
  local jupynium = require("jupynium")
  local bufnr = vim.api.nvim_get_current_buf()
  jupynium.setup({
    python_host = { "conda", "run", "--no-capture-output", "-n", "jupynium", "python" },
    default_notebook_URL = "localhost:8888",
    jupyter_command = { "conda", "run", "--no-capture-output", "-n", "base", "jupyter" },
  })
  jupynium.set_default_keymaps(bufnr)
  require("jupynium.textobj").set_default_keymaps(bufnr)
end

return M
