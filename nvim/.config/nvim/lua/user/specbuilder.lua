local M = {
  plugin_spec = {},
}

---Add the module `modname` to the spec table `plugin_spec` intended for use with `lazy.nvim`
---@param modname string
---@return nil
function M.include(modname)
  table.insert(M.plugin_spec, { import = modname })
end

return M
