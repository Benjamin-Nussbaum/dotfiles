local M = {
  "neovim/nvim-lspconfig",
  cmd = { "LspInfo", "LspInstall", "LspStart" },
  event = { "BufReadPre", "BufNewFile" },
  dependencies = { "folke/neodev.nvim" },
}

function M.toggle_inlay_hints()
  local hint = vim.lsp.inlay_hint
  hint.enable(0, not hint.is_enabled(0))
end

function M.config()
  local lspconfig = require("lspconfig")
  local icons = require("user.icons")

  local servers = {
    "lua_ls",
    "cssls",
    "html",
    "pyright",
    "ruff_lsp",
    "bashls",
    "jsonls",
    "yamlls",
    "marksman",
    "eslint",
    "rust_analyzer",
  }

  local default_diagnostic_config = {
    signs = {
      active = true,
      values = {
        { name = "DiagnosticSignError", text = icons.diagnostics.Error },
        { name = "DiagnosticSignWarn", text = icons.diagnostics.Warning },
        { name = "DiagnosticSignHint", text = icons.diagnostics.Hint },
        { name = "DiagnosticSignInfo", text = icons.diagnostics.Information },
      },
    },
    virtual_text = false,
    update_in_insert = false,
    underline = true,
    severity_sort = true,
    float = {
      focusable = true,
      style = "minimal",
      border = "rounded",
      source = "always",
      header = "",
      prefix = "",
    },
  }

  vim.diagnostic.config(default_diagnostic_config)

  for _, sign in ipairs(vim.tbl_get(vim.diagnostic.config() or {}, "signs", "values") or {}) do
    vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = sign.name })
  end

  vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
  vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })
  require("lspconfig.ui.windows").default_options.border = "rounded"

  local function on_attach(client, bufnr)
    local function map(mode, lhs, rhs, desc, opts)
      local defaults = { silent = true, desc = desc or "" }
      opts = vim.tbl_deep_extend("force", defaults, opts or {})
      opts.buffer = bufnr
      vim.keymap.set(mode, lhs, rhs, opts)
    end

    -- map("n", "K", vim.lsp.buf.hover, "Keyword hover")
    map("n", "K", function()
      if not require("ufo").peekFoldedLinesUnderCursor() then
        vim.lsp.buf.hover()
      end
    end, "Keyword hover")

    map("n", "<F2>", vim.lsp.buf.rename, "Rename")
    map({ "n", "i" }, "<F3>", vim.lsp.buf.format, "Format")
    map({ "n", "v" }, "<F4>", vim.lsp.buf.code_action, "Code action")

    map("n", "gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
    map("n", "gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
    map("n", "gi", vim.lsp.buf.implementation, "[G]oto [I]mplementation")
    map("n", "gK", vim.lsp.buf.signature_help, "[G]et [S]ignature")
    map("i", "<C-l>", vim.lsp.buf.signature_help, "[G]et [S]ignature")
    map("n", "go", vim.lsp.buf.type_definition, "[G]oto type definition")
    map("n", "gr", vim.lsp.buf.references, "[G]oto [R]eferences")
    map("n", "gS", vim.lsp.buf.workspace_symbol, "Workspace symbols")

    map("n", "gl", vim.diagnostic.open_float, "Open float")
    map("n", "[d", vim.diagnostic.goto_prev, "Previous diagnostic")
    map("n", "]d", vim.diagnostic.goto_next, "Next diagnostic")

    map("n", "<leader>lh", M.toggle_inlay_hints, "[L]sp toggle inlay [H]ints")
    map("n", "<leader>li", "<cmd>LspInfo<cr>", "[L]sp [I]nfo")
    map("n", "<leader>ll", vim.lsp.codelens.run, "[L]sp code[l]ens")
    map("n", "<leader>lq", vim.diagnostic.setloclist, "Quickfix list")

    local install_ok, wk = pcall(require, "which-key")
    if install_ok then
      wk.register({ ["<leader>l"] = { name = "[L]SP" } }, { buffer = bufnr })
    end

    if client.supports_method("textDocument/inlayHint") then
      vim.lsp.inlay_hint.enable(bufnr, true)
    end
  end

  local common_capabilities = vim.lsp.protocol.make_client_capabilities()
  common_capabilities.textDocument.completion.completionItem.snippetSupport = true

  for _, server in pairs(servers) do
    local opts = {
      on_attach = on_attach,
      capabilities = common_capabilities,
    }

    local require_ok, settings = pcall(require, "user.lspsettings." .. server)
    if require_ok then
      opts = vim.tbl_deep_extend("force", settings, opts)
    end

    if server == "lua_ls" then
      require("neodev").setup({})
    end

    if server == "pyright" then
      opts.before_init = function(params, config)
        local Path = require("plenary.path")
        local venv = Path:new((config.root_dir:gsub("/", Path.path.sep)), ".venv")
        if venv:joinpath("bin"):is_dir() then
          config.settings.python.pythonPath = tostring(venv:joinpath("bin", "python"))
        else
          config.settings.python.pythonPath = tostring(venv:joinpath("Scripts", "python.exe"))
        end
      end
    end

    if server == "ruff_lsp" then
      opts = vim.tbl_deep_extend("force", opts, {
        on_attach = function(client, bufnr)
          -- Disable hover in favor of Pyright
          client.server_capabilities.hoverProvider = false
        end,
      })
    end

    lspconfig[server].setup(opts)
  end
end

return M
