local M = {
  "goolord/alpha-nvim",
  event = "VimEnter",
}

function M.config()
  local dashboard = require("alpha.themes.dashboard")
  local icons = require("user.icons")

  local green = vim.g.terminal_color_2
  local blue = vim.g.terminal_color_4
  vim.api.nvim_set_hl(0, "NeovimDashboardLogo1", { fg = blue })
  vim.api.nvim_set_hl(0, "NeovimDashboardLogo2", { fg = green, bg = blue })
  vim.api.nvim_set_hl(0, "NeovimDashboardLogo3", { fg = green })

  dashboard.section.header.val = {
    [[      █  █      ]],
    [[      ██ ██      ]],
    [[      █████      ]],
    [[      ██ ███      ]],
    [[      █  █      ]],
    [[                   ]],
    [[ n  e  o   v  i  m ]],
  }

  dashboard.section.header.opts.hl = {
    { { "NeovimDashboardLogo1", 6, 8 }, { "NeovimDashboardLogo3", 9, 22 } },
    { { "NeovimDashboardLogo1", 6, 8 }, { "NeovimDashboardLogo2", 9, 11 }, { "NeovimDashboardLogo3", 12, 24 } },
    { { "NeovimDashboardLogo1", 6, 11 }, { "NeovimDashboardLogo3", 12, 26 } },
    { { "NeovimDashboardLogo1", 6, 11 }, { "NeovimDashboardLogo3", 12, 24 } },
    { { "NeovimDashboardLogo1", 6, 11 }, { "NeovimDashboardLogo3", 12, 22 } },
    {},
    { { "Keyword", 1, 20 } },
  }

  local function button(sc, txt, keybind, keybind_opts)
    local b = dashboard.button(sc, txt, keybind, keybind_opts)
    b.opts.hl_shortcut = "Include"
    return b
  end

  dashboard.section.buttons.val = {
    button("f", icons.ui.Files .. "  Find file", ":Telescope find_files <CR>"),
    button("n", icons.ui.NewFile .. "  New file", ":ene <BAR> startinsert <CR>"),
    button("p", icons.git.Repo .. "  Find project", ":lua require('telescope').extensions.project.project()<CR>"),
    button("o", icons.ui.History .. "  Open recent file", ":Telescope oldfiles <CR>"),
    button("t", icons.ui.Text .. "  Find text", ":Telescope live_grep <CR>"),
    button("c", icons.ui.Gear .. "  Config", ":e ~/.config/nvim/init.lua <CR>"),
    button("q", icons.ui.SignOut .. "  Quit", ":qa<CR>"),
  }

  dashboard.opts.opts.noautocmd = true
  require("alpha").setup(dashboard.opts)

  local fortune = require("alpha.fortune")()
  dashboard.section.footer.val = fortune
  dashboard.section.footer.opts.hl = "Type"

  vim.api.nvim_create_autocmd("User", {
    once = true,
    pattern = "LazyVimStarted",
    callback = function()
      local stats = require("lazy").stats()
      local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
      local report = {
        type = "text",
        val = icons.kind.Event .. stats.loaded .. " / " .. stats.count .. " plugins loaded in " .. ms .. " ms",
        opts = {
          position = "center",
          hl = "Comment",
        },
      }

      dashboard.config.layout = {
        { type = "padding", val = 2 },
        dashboard.section.header,
        { type = "padding", val = 2 },
        dashboard.section.buttons,
        report,
        dashboard.section.footer,
      }

      pcall(vim.cmd.AlphaRedraw)
    end,
  })

  vim.api.nvim_create_autocmd({ "User" }, {
    pattern = { "AlphaReady" },
    callback = function()
      vim.cmd([[
      set laststatus=0 | autocmd BufUnload <buffer> set laststatus=3
    ]])
    end,
  })
end

return M
