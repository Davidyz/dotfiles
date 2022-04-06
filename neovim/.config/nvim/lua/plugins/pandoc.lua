vim.g["pandoc#modules#enabled"] = {
  "formatting",
  "bibliographies",
  "completion",
  "metadata",
  "menu",
  "keyboard",
  "toc",
  "spell",
}
vim.g["pandoc#modules#disabled"] = { "folding", "hypertext", "conceal" }
vim.g["pandoc#syntax#conceal#use"] = 0
table.insert(vim.g["pandoc#filetypes#handled"], "markdown")
vim.g["pandoc#filetypes#pandoc_markdown"] = 0
vim.g["pandoc#spell#enabled"] = 0
