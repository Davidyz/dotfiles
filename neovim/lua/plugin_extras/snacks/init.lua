return setmetatable({}, {
  __index = function(_, key)
    return require("plugin_extras.snacks." .. key)
  end,
})
