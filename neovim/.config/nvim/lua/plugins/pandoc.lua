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
if vim.g["pandoc#filetypes#handled"] ~= nil then
  table.insert(vim.g["pandoc#filetypes#handled"], "markdown")
else
  vim.g["pandoc#filetypes#handled"] = { "markdown" }
end
vim.g["pandoc#filetypes#pandoc_markdown"] = 0
vim.g["pandoc#spell#enabled"] = 0
