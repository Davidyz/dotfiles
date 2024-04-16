local utils = require("_utils")

local items = {
  "filetype.json",
  "filetype.xml",
  "filetype.yaml",

  "filetype.lua",
  "filetype.python",
  "filetype.tex",
  "filetype.typescript",
  "filetype.vim",

  "filetype.fstab",
  "filetype.gitcommit",
  "filetype.pandoc",
  "filetype.markdown",
  "filetype.html",
  "filetype.sshconfig",
}
utils.tryRequire(items)
