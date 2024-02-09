local M = {
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
    },
    "nvim-telescope/telescope-ui-select.nvim",
    "nvim-telescope/telescope-project.nvim",
  },
  cmd = "Telescope",
  event = "VeryLazy",
}

function M.filenameFirst(_, path)
  local tail = vim.fs.basename(path)
  local parent = vim.fs.dirname(path)
  if parent == "." then
    return tail
  end
  return string.format("%s\t\t%s", tail, parent)
end

function M.config()
  -- See https://github.com/nvim-telescope/telescope.nvim/issues/2014#issuecomment-1873229658
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "TelescopeResults",
    callback = function(ctx)
      vim.api.nvim_buf_call(ctx.buf, function()
        vim.fn.matchadd("TelescopeParent", "\t\t.*$")
        vim.api.nvim_set_hl(0, "TelescopeParent", { link = "Comment" })
      end)
    end,
  })

  local icons = require("user.icons")
  local telescope = require("telescope")
  local builtin = require("telescope.builtin")
  local actions = require("telescope.actions")

  local dropdown = { theme = "dropdown" }
  local dropdown_normal = { theme = "dropdown", initial_mode = "normal" }
  telescope.setup({
    defaults = {
      prompt_prefix = icons.ui.Telescope .. " ",
      selection_caret = icons.ui.Forward .. " ",
      entry_prefix = "   ",
      initial_mode = "insert",
      selection_strategy = "reset",
      path_display = { "smart" },
      color_devicons = true,
      vimgrep_arguments = {
        "rg",
        "--color=never",
        "--no-heading",
        "--with-filename",
        "--line-number",
        "--column",
        "--smart-case",
        "--hidden",
        "--glob=!.git/",
      },
      mappings = {
        i = {
          ["<C-n>"] = actions.cycle_history_next,
          ["<C-p>"] = actions.cycle_history_prev,
          ["<C-j>"] = actions.move_selection_next,
          ["<C-k>"] = actions.move_selection_previous,
          ["<M-j>"] = actions.move_selection_next,
          ["<M-k>"] = actions.move_selection_previous,
        },
        n = {
          ["<esc>"] = actions.close,
          ["j"] = actions.move_selection_next,
          ["k"] = actions.move_selection_previous,
          ["q"] = actions.close,
        },
      },
    },
    pickers = {
      current_buffer_fuzzy_find = dropdown,
      live_grep = dropdown,
      grep_string = dropdown,
      lsp_references = dropdown_normal,
      lsp_definitions = dropdown_normal,
      lsp_declarations = dropdown_normal,
      lsp_implementations = dropdown_normal,
      find_files = {
        theme = "dropdown",
        previewer = false,
        hidden = true,
        path_display = M.filenameFirst,
      },
      buffers = {
        theme = "dropdown",
        previewer = false,
        initial_mode = "normal",
        mappings = {
          i = {
            ["<C-d>"] = actions.delete_buffer,
          },
          n = {
            ["dd"] = actions.delete_buffer,
          },
        },
      },
      colorscheme = {
        enable_preview = true,
      },
    },
    extensions = {
      ["ui-select"] = {
        require("telescope.themes").get_dropdown({}),
      },
      project = {
        theme = "dropdown",
      },
    },
  })

  -- Skip explicit calls to enable lazy loading
  -- telescope.load_extension("fzf")
  -- telescope.load_extension("ui-select")
  -- telescope.load_extension("project")

  -- Telescope live_grep in git root
  -- Function to find the git root directory based on the current buffer's path
  -- See https://github.com/nvim-lua/kickstart.nvim/blob/master/init.lua
  local function find_git_root()
    -- Use the current buffer's path as the starting point for the git search
    local current_file = vim.api.nvim_buf_get_name(0)
    local current_dir
    local cwd = vim.fn.getcwd()
    -- If the buffer is not associated with a file, return nil
    if current_file == "" then
      current_dir = cwd
    else
      -- Extract the directory from the current file's path
      current_dir = vim.fn.fnamemodify(current_file, ":h")
    end

    -- Find the Git root directory from the current file's path
    ---@diagnostic disable-next-line: param-type-mismatch
    local git_root = vim.fn.systemlist("git -C " .. vim.fn.escape(current_dir, " ") .. " rev-parse --show-toplevel")[1]
    if vim.v.shell_error ~= 0 then
      print("Not a git repository. Searching on current working directory")
      return cwd
    end
    return git_root
  end

  -- Custom live_grep function to search in git root
  local function live_grep_git_root()
    local git_root = find_git_root()
    if git_root then
      builtin.live_grep({
        search_dirs = { git_root },
      })
    end
  end

  local function nmap(lhs, rhs, desc)
    local opts = { silent = true, desc = desc or "" }
    local mode = "n"
    vim.keymap.set(mode, lhs, rhs, opts)
  end

  nmap("<leader>/", builtin.current_buffer_fuzzy_find, "Fuzzy search current buffer")

  nmap("<leader>gb", builtin.git_branches, "Search [G]it [B]ranches")
  nmap("<leader>gf", builtin.git_files, "Search [G]it [F]iles")

  nmap("<leader>sa", builtin.autocommands, "[S]earch [A]utocommands")
  nmap("<leader>sb", builtin.buffers, "[S]earch [B]uffers")
  nmap("<leader>sc", builtin.colorscheme, "[S]earch [C]olorschemes")
  nmap("<leader>sC", builtin.commands, "[S]earch [C]ommands")
  nmap("<leader>sd", builtin.diagnostics, "[S]earch [D]iagnostics")
  nmap("<leader>sf", builtin.find_files, "[S]earch [F]iles")
  nmap("<leader>sg", builtin.live_grep, "[S]earch with [G]rep")
  nmap("<leader>sG", live_grep_git_root, "[S]earch with [G]rep on git root")
  nmap("<leader>sh", builtin.help_tags, "[S]earch [H]elp")
  nmap("<leader>sH", builtin.highlights, "[S]earch [H]ighlights")
  nmap("<leader>sk", builtin.keymaps, "[S]earch [K]eymaps")
  nmap("<leader>sl", builtin.resume, "[S]earch [L]ast")
  nmap("<leader>sm", builtin.marks, "[S]earch [M]arks")
  nmap("<leader>sM", builtin.man_pages, "[S]earch [M]anual")
  nmap("<leader>so", builtin.oldfiles, "[S]earch recently [O]pened files")
  nmap("<leader>sp", telescope.extensions.project.project, "[S]earch [P]rojects")
  nmap("<leader>sr", builtin.lsp_references, "[S]earch [R]eferences")
  nmap("<leader>ss", builtin.lsp_document_symbols, "[S]earch document [S]mbols")
  nmap("<leader>sS", builtin.lsp_dynamic_workspace_symbols, "[S]earch workspace [S]mbols")
  nmap("<leader>sT", builtin.builtin, "[S]earch all [T]elescope builtins")
  nmap("<leader>sw", builtin.grep_string, "[S]earch current [W]ord")

  local install_ok, wk = pcall(require, "which-key")
  if install_ok then
    wk.register({
      ["<leader>g"] = { name = "[G]it" },
      ["<leader>s"] = { name = "[S]earch" },
    })
  end
end

return M
