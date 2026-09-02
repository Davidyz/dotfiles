return setmetatable({
  dap = nil, ---@module "plugin_extras.snacks.dap"
}, {
  __index = function(_, key)
    return require("plugin_extras.snacks." .. key)
  end,
})
