local km_utils = require("keymaps.utils")

for _, ft in ipairs(TEXT) do
  vim.api.nvim_create_autocmd("FileType", {
    pattern = ft,
    callback = function()
      km_utils.setKeymap(
        "n",
        "mp",
        ":MarkdownPreviewToggle<CR>",
        { noremap = true, silent = true }
      )
    end,
  })
end
