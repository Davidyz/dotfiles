vim.g.coc_global_extensions = {
  "coc-markdownlint",
  "coc-pyright",
  "coc-highlight",
  "coc-java",
  "coc-vimlsp",
  "coc-sh",
  "coc-tsserver",
  "coc-clangd",
  "coc-snippets",
  "coc-spell-checker",
  "coc-rainbow-fart",
  "coc-marketplace",
  "coc-grammarly",
  "coc-json",
  "coc-git",
  "coc-ci",
  "coc-docker",
  "coc-lua",
  "coc-phpls",
  "coc-prettier",
}

vim.api.nvim_create_autocmd("BufEnter", {
  pattern = "*.py",
  callback = function()
    vim.b.coc_root_patterns = {
      "Pipfile.lock",
      ".git",
      ".env",
      "venv",
      ".venv",
      "setup.cfg",
      "setup.py",
      "pyproject.toml",
      "pyrightconfig.json",
    }
  end,
})

vim.api.nvim_create_autocmd("BufRead", {
  pattern = "*.md,*.markdown",
  callback = function()
    vim.g.coc_filetype_map = { ["pandoc"] = "markdown" }
  end,
})
