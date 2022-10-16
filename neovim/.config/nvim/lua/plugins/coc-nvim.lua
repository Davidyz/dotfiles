local utils = require("_utils")

local extensions = {
  -- mappings from plugin to required runtime.
  ["coc-pyright"] = { "python", "python3" },
  ["coc-java"] = { "java", "javac" },
  ["coc-sh"] = { "bash", "sh" },
  ["coc-tsserver"] = { "node" },
  ["coc-clangd"] = { "gcc", "clang", "msvc" },
  ["coc-phpls"] = { "php" },
  ["coc-docker"] = { "docker" },
  ["coc-bibtex"] = { "texlive", "pandoc" },
}

vim.g.coc_global_extensions = {
  "coc-markdownlint",
  "coc-highlight",
  "coc-vimlsp",
  "coc-snippets",
  "coc-spell-checker",
  "coc-rainbow-fart",
  "coc-marketplace",
  "coc-markdownlint",
  "coc-json",
  "coc-git",
  "coc-ci",
  "coc-phpls",
  "coc-prettier",
  "coc-lua",
}

for plugin, exec in pairs(extensions) do
  if utils.any(exec, vim.fn.executable) then
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

if vim.g.vscode ~= 1 then
  vim.api.nvim_create_autocmd("CursorHold", {
    pattern = "*",
    callback = function()
      if vim.fn["CocActionAsync"] ~= nil then
        vim.fn["CocActionAsync"]("highlight")
      end
    end,
  })

  vim.api.nvim_set_hl(0, "CocHighlightText", vim.api.nvim_get_hl_by_name("TermCursorNC", {}))
end
