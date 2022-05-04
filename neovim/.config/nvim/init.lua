local utils = require("utils")
local items = {
  "plugins.main",
  "colorscheme.main",
  "keymaps.main",
  "filetype.main",
  "misc",
}
utils.tryRequire(items)
