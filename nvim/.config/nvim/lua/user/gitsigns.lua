local M = {
  "lewis6991/gitsigns.nvim",
  cmd = "Gitsigns",
  event = { "BufReadPost", "BufNewFile" },
}

function M.config()
  local icons = require("user.icons")
  local gitsigns = require("gitsigns")

  local function on_attach(bufnr)
    local function nmap(lhs, rhs, desc, opts)
      local defaults = { silent = true, desc = desc or "" }
      opts = vim.tbl_deep_extend("force", defaults, opts or {})
      opts.buffer = bufnr
      vim.keymap.set("n", lhs, rhs, opts)
    end

    nmap("<leader>gd", "<cmd>Gitsigns diffthis HEAD<cr>", "Git Diff")
    nmap("<leader>gh", gitsigns.preview_hunk, "Preview Hunk")
    nmap("<leader>gl", gitsigns.blame_line, "Blame")
    nmap("<leader>gr", gitsigns.reset_hunk, "Reset Hunk")
    nmap("<leader>gR", gitsigns.reset_buffer, "Reset Buffer")
    nmap("<leader>gs", gitsigns.stage_hunk, "Stage Hunk")
    nmap("<leader>gu", gitsigns.undo_stage_hunk, "Undo Stage Hunk")

    -- don't override the built-in and fugitive keymaps
    local gs = package.loaded.gitsigns
    vim.keymap.set({ "n", "v" }, "]c", function()
      if vim.wo.diff then
        return "]c"
      end
      vim.schedule(function() gs.next_hunk() end)
      return "<Ignore>"
    end, { expr = true, buffer = bufnr, desc = "Jump to next hunk" })
    vim.keymap.set({ "n", "v" }, "[c", function()
      if vim.wo.diff then
        return "[c"
      end
      vim.schedule(function() gs.prev_hunk() end)
      return "<Ignore>"
    end, { expr = true, buffer = bufnr, desc = "Jump to previous hunk" })
  end

  require("gitsigns").setup({
    signs = {
      add = { text = "+" },
      change = { text = "~" },
      delete = { text = "_" },
      topdelete = { text = "‾" },
      changedelete = { text = "~" },
    },
    on_attach = on_attach,
  })
end

return M
