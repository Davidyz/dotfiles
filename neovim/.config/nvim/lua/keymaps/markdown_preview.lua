require("utils")

for _, ft in ipairs(TEXT) do
  vim.api.nvim_create_autocmd("FileType", {
    pattern = ft,
    callback = function()
      Set_keymap("n", "mp", ":MarkdownPreviewToggle<CR>", { noremap = true, silent = true })
    end,
  })
end
