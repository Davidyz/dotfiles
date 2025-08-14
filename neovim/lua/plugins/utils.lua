M = {}

M.mason_packages = {
  "actionlint",
  "basedpyright",
  "bash-language-server",
  "clang-format",
  "clangd",
  "clangd",
  "debugpy",
  "editorconfig-checker",
  "harper-ls",
  "html-lsp",
  "jsonls",
  "lua-language-server",
  "prettierd",
  "ruff",
  "shellcheck",
  "shfmt",
  "stylua",
  "taplo",
  "ty",
  "tree-sitter-cli",
  "vim-language-server",
  "yaml-language-server",
}

M.treesitter_parsers = {
  "python",
  "c",
  "comment",
  "cpp",
  "gitcommit",
  "javascript",
  "json5",
  "make",
  "regex",
  "lua",
  "luadoc",
  "regex",
  "toml",
  "markdown_inline",
  "vim",
  "yaml",
  "vimdoc",
  "git_rebase",
  "gitattributes",
}

local conditionals = {
  ["arduino-cli"] = "arduino-language-server",
  arduino = "arduino-language-server",
  cmake = { "cmakelang", "cmake-language-server" },
  docker = { "dockerfile-language-server", "docker-compose-language-service" },
  javac = "jdtls",
  node = { "typescript-language-server" },
  pdflatex = { "texlab", "latexindent" },
  rustc = "rust-analyzer",
  tex = "texlab",
}

for exe, ls in pairs(conditionals) do
  if vim.fn.executable(exe) ~= 0 then
    if type(ls) == "string" then
      table.insert(M.mason_packages, ls)
    elseif type(ls) == "table" then
      vim.list_extend(M.mason_packages, ls)
    end
  end
end

return M
