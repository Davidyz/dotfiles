local highlight = vim.api.nvim_get_hl_by_name("TermCursorNC", {})
highlight.cterm = vim.empty_dict()
highlight.bg = highlight.bg or highlight.background
vim.api.nvim_set_hl(0, "IlluminatedWordText", highlight)
vim.api.nvim_set_hl(0, "IlluminatedWordRead", highlight)
vim.api.nvim_set_hl(0, "IlluminatedWordWrite", highlight)
