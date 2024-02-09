local M = {
  "NvChad/nvim-colorizer.lua",
  event = { "BufReadPost", "BufNewFile" },
}

function M.config()
  require("colorizer").setup({
    user_default_options = {
      names = false,
      rgb_fn = true,
      hsl_fn = true,
    },
  })
end

return M
