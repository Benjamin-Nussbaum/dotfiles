return {
  on_new_config = function(new_config, new_root_dir)
    new_config.settings.texlab.rootDirectory = new_root_dir
  end,
  settings = {
    texlab = {
      rootDirectory = vim.fn.getcwd(),
      build = {
        executable = "latexmk",
        args = { "-pdf", "-interaction=nonstopmode", "-synctex=1", "%f" },
        onSave = true,
        forwardSearchAfter = false,
      },
      forwardSearch = {
        executable = "zathura",
        args = {
          "--synctex-editor-command",
          [[nvim-texlabconfig -file '%%%{input}' -line %%%{line} -server ]] .. vim.v.servername,
          "--synctex-forward",
          "%l:1:%f",
          "%p",
        },
      },
      chktex = {
        onOpenAndSave = true,
        onEdit = true,
      },
      diagnosticsDelay = 300,
      latexFormatter = "latexindent",
      latexindent = {
        ["local"] = nil, -- local is a reserved keyword
        modifyLineBreaks = true,
      },
      bibtexFormatter = "texlab",
      formatterLineLength = 120,
    },
  },
}
