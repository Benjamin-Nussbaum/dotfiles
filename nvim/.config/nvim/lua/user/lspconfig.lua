local M = {
  "neovim/nvim-lspconfig",
  cmd = { "LspInfo", "LspInstall", "LspStart" },
  event = { "BufReadPre", "BufNewFile" },
  dependencies = { "folke/neodev.nvim" },
}

function M.toggle_inlay_hints()
  local hint = vim.lsp.inlay_hint
  hint.enable(not hint.is_enabled({ 0 }), { 0 })
end

function M.config()
  local lspconfig = require("lspconfig")
  local icons = require("user.icons")

  local servers = {
    "lua_ls",
    "cssls",
    "html",
    "pyright",
    "basedpyright",
    "ruff",
    "gopls",
    "bashls",
    "jsonls",
    "yamlls",
    "marksman",
    -- "remark_ls",
    "texlab",
    "eslint",
    "rust_analyzer",
    "taplo",
  }

  -- Equivalent to the python list comprehension: [ item.field for item in tbl ]
  local function extract_field(tbl, field)
    return vim.tbl_map(function(t)
      return t[field]
    end, tbl)
  end

  local sign_config = {
    -- Must be in the same order as vim.diagnostic.severity
    { text = icons.diagnostics.Error, texthl = "DiagnosticSignError" },
    { text = icons.diagnostics.Warning, texthl = "DiagnosticSignWarn" },
    { text = icons.diagnostics.Information, texthl = "DiagnosticSignInfo" },
    { text = icons.diagnostics.Hint, texthl = "DiagnosticSignHint" },
  }

  local default_diagnostic_config = {
    signs = {
      text = extract_field(sign_config, "text"),
      texthl = extract_field(sign_config, "texthl"),
      -- linelh = extract_field(sign_config, "texthl"),
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
    -- map({ "n", "i" }, "<F3>", vim.lsp.buf.format, "Format")
    map({ "n", "v" }, "<F4>", vim.lsp.buf.code_action, "Code action")

    map("n", "gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
    map("n", "gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
    map("n", "gi", vim.lsp.buf.implementation, "[G]oto [I]mplementation")
    map("n", "gK", vim.lsp.buf.signature_help, "[G]et [S]ignature")
    map("i", "<C-l>", vim.lsp.buf.signature_help, "[G]et [S]ignature")
    map("n", "go", vim.lsp.buf.type_definition, "[G]oto type definition")
    -- map("n", "gr", vim.lsp.buf.references, "[G]oto [R]eferences")
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
      wk.add({ { "<leader>l", group = "[L]SP", buffer = bufnr } })
    end

    if client.supports_method("textDocument/inlayHint") then
      vim.lsp.inlay_hint.enable(true, { bufnr })
    end

    local function code_action_sync(action)
      local params = vim.lsp.util.make_range_params(nil, vim.lsp.util._get_offset_encoding())
      params.context = { only = { action } }

      local resp = client.request_sync("textDocument/codeAction", params, 3000, bufnr)
      for _, r in pairs(resp and resp.result or {}) do
        if r.edit then
          vim.lsp.util.apply_workspace_edit(r.edit, vim.lsp.util._get_offset_encoding(bufnr))
        else
          vim.lsp.buf.execute_command(r.command)
        end
      end
    end

    if client.supports_method("textDocument/formatting") then
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = vim.api.nvim_create_augroup("LspFormatting", {}),
        buffer = bufnr,
        callback = function()
          code_action_sync("source.organizeImports")
          code_action_sync("source.fixAll")
          vim.lsp.buf.format()
        end,
      })
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

    if server == "basedpyright" then
      opts = vim.tbl_deep_extend("force", opts, {
        on_attach = function(client, bufnr)
          on_attach(client, bufnr)
          -- Disable hover in favor of Pyright
          client.server_capabilities.hoverProvider = false
        end,
        settings = {
          basedpyright = {
            disableOrganizeImports = true,
            -- https://github.com/DetachHead/basedpyright/issues/203
            typeCheckingMode = "off",
          },
        },
      })
    end

    if server == "ruff" then
      opts = vim.tbl_deep_extend("force", opts, {
        on_attach = function(client, bufnr)
          -- Disable hover in favor of Pyright
          client.server_capabilities.hoverProvider = false
        end,
        init_options = {
          settings = {
            -- Any extra CLI arguments for `ruff` go here.
            -- args = {},
            args = { "--fix" },
          },
        },
      })
    end

    lspconfig[server].setup(opts)
  end
end

return M
