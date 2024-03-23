local ft_utils = require("filetype.utils")
vim.api.nvim_create_autocmd("BufNewFile", {
  pattern = "*.java",
  callback = function()
    ft_utils.initTemplate(
      "java",
      { "public class " .. vim.fn.expand("%:t:r") .. "{", "", "}" },
      function()
        return vim.g.editting_code_block ~= true
      end,
      2
    )
  end,
})
-- vim.api.nvim_create_autocmd("BufWritePre", { pattern = "*.java", callback = ft_utils.format("google-java-format", "-") })
