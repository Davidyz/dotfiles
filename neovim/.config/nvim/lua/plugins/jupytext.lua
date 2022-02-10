vim.g.jupytext_enable = 1
vim.g.jupytext_fmt = 'py:light'
vim.api.nvim_command('au BufEnter *.ipynb set ft=ipynb')
