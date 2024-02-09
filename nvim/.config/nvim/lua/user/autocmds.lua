local function augroup(name) return vim.api.nvim_create_augroup(name, { clear = true }) end

-- Supposed to auto-reload config files but seems bugged
vim.api.nvim_create_autocmd({ "BufWritePost" }, {
  pattern = vim.fn.stdpath("config") .. "/**/*.lua",
  group = augroup("reload_config"),
  callback = function()
    for name, _ in pairs(package.loaded) do
      if name:match("^" .. vim.env.USER) then -- clear the cache
        package.loaded[name] = nil
      end
    end
    -- source the init.lua file
    dofile(vim.env.MYVIMRC)
    vim.notify("Reloading config...", vim.log.levels.INFO)
  end,
})

vim.api.nvim_create_autocmd({ "FileType" }, {
  group = augroup("q_to_quit"),
  pattern = {
    "checkhealth",
    "git",
    "help",
    "lab",
    "lspinfo",
    "man",
    "notify",
    "oil",
    "qf",
    "query",
    "spectre_panel",
    "startuptime",
    "tsplayground",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
  end,
})

vim.api.nvim_create_autocmd({ "FileType" }, {
  group = augroup("netrw_keymaps"),
  pattern = { "netrw" },
  callback = function(ev)
    local function map(mode, lhs, rhs, opts)
      opts = opts or { remap = true }
      opts.buffer = ev.buf
      vim.keymap.set(mode, lhs, rhs, opts)
    end
    map("n", "q", "<cmd>Lexplore<cr>", { nowait = true })
    map("n", "l", "<cr>")
    map("n", "L", "<cr><cmd>Lexplore<cr>")
    map("n", "P", "<C-w>z")
  end,
})

-- :checkt[ime]		Check if any buffers were changed outside of Vim.
vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  group = augroup("checktime"),
  command = "checktime",
})

vim.api.nvim_create_autocmd({ "TextYankPost" }, {
  group = augroup("highlight_on_yank"),
  callback = function() vim.highlight.on_yank({ higroup = "Visual", timeout = 40 }) end,
})

vim.api.nvim_create_autocmd({ "VimResized" }, {
  group = augroup("resize_splits"),
  command = "tabdo wincmd =",
})

vim.api.nvim_create_autocmd({ "FileType" }, {
  group = augroup("wrap_spell"),
  pattern = { "gitcommit", "markdown" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})

-- Create any missing directories when saving a file
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  group = augroup("auto_create_dir"),
  callback = function(event)
    if event.match:match("^%w%w+://") then
      return
    end
    local file = vim.loop.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
})
