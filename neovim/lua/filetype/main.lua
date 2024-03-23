local utils = require("_utils")

local items = {
  "filetype.json",
  "filetype.xml",
  "filetype.yaml",

  "filetype.python",
  "filetype.tex",
  "filetype.typescript",
  "filetype.vim",

  "filetype.gitcommit",
  "filetype.pandoc",
  "filetype.markdown",
  "filetype.html",
}
utils.tryRequire(items)
