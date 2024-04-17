local M = {
  "polarmutex/git-worktree.nvim",
  branch = "v2",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
  },
  event = "VeryLazy",
}

function M.config()
  require("git-worktree"):setup({
    change_directory_command = "tcd",
  })

  local status_ok, telescope = pcall(require, "telescope")
  if status_ok then
    telescope.load_extension("git_worktree")

    vim.keymap.set("n", "<leader>gw", function()
      telescope.extensions.git_worktree.git_worktrees()
    end, { desc = "List Worktrees" })
    vim.keymap.set("n", "<leader>ga", function()
      telescope.extensions.git_worktree.create_git_worktree()
    end, { desc = "Add Worktree" })
  end
end

return M
