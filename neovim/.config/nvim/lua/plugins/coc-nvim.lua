require("utils")

local extensions = {
  -- mappings from plugin to required runtime.
  ["coc-pyright"] = { "python", "python3" },
  ["coc-java"] = { "java", "javac" },
  ["coc-sh"] = { "bash", "sh" },
  ["coc-tsserver"] = { "node" },
  ["coc-clangd"] = { "gcc", "clang", "msvc" },
  ["coc-phpls"] = { "php" },
}

vim.g.coc_global_extensions = {
  "coc-markdownlint",
  "coc-highlight",
  "coc-vimlsp",
  "coc-snippets",
  "coc-spell-checker",
  "coc-rainbow-fart",
  "coc-marketplace",
  "coc-grammarly",
  "coc-json",
  "coc-git",
  "coc-ci",
  "coc-docker",
  "coc-phpls",
  "coc-prettier",
  "coc-lua",
}

for plugin, exec in pairs(extensions) do
  if any(exec, vim.fn.executable) then
    -- only load extensions for which the runtime is found on local machine.
    table.insert(vim.g.coc_global_extensions, plugin)
  end
end

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

vim.api.nvim_create_autocmd("CursorHold", {
  pattern = "*",
  callback = function()
    vim.fn["CocActionAsync"]("highlight")
  end,
})
vim.api.nvim_command([[
hi clear CocHighlightText
hi link CocHighlightText Pmenu
]])
