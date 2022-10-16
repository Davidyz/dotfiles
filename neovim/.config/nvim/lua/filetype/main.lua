local utils = require("_utils")

local items = {
  "filetype.json",
  "filetype.xml",
  "filetype.yaml",

  "filetype.c_cpp",
  "filetype.java",
  "filetype.lua",
  "filetype.haskell",
  "filetype.php",
  "filetype.python",
  "filetype.sh",
  "filetype.typescript",
  "filetype.vim",
  "filetype.zsh",

  "filetype.gitcommit",
  "filetype.pandoc",
  "filetype.markdown",
  "filetype.html",
  "filetype.bib",
}
utils.tryRequire(items)
