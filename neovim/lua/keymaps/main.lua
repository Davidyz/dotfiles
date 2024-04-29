local utils = require("_utils")

local items = {
  "keymaps.global",

  -- "keymaps.copilot",
  -- "keymaps.dap",
  -- "keymaps._lsp",
  -- "keymaps.markdown_preview",
  -- "keymaps.NERDTree",
  -- "keymaps.NERDCommenter",
  -- "keymaps.telescope",

  "keymaps.help",
  "keymaps.python",
  "keymaps.shell",
  "keymaps.c",
}

utils.tryRequire(items)
