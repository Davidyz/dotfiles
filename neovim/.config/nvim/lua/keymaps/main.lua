local utils = require("utils")

local items = {
  "keymaps.global",

  "keymaps.black",
  "keymaps.coc-nvim",
  "keymaps.golden_view",
  "keymaps.markdown_preview",
  "keymaps.NERDTree",
  "keymaps.NERDCommenter",
  "keymaps.whichkey",

  "keymaps.python",
  "keymaps.shell",
  "keymaps.c",
}

utils.tryRequire(items)
