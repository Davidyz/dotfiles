local utils = require("_utils")

local items = {
  "keymaps.global",

  "keymaps.help",
  "keymaps.shell",
}

utils.tryRequire(items)
