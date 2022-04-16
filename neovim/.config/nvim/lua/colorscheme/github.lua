local style = "dark_default"
require("github-theme").setup({
  theme_style = style,
  comment_style = "italic",
  keyword_style = "italic",
})

vim.api.nvim_command("colorscheme github_" .. style)
