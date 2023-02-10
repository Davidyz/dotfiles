M = {}

M.mason_packages = {
  "black",
  "flake8",
  "clang-format",
  "shellcheck",
  "stylua",
  "clangd",
  "lua-language-server",
  "vim-language-server",
  "bash-language-server",
  "pyright",
  "isort",
  "jq",
  "clangd",
  "beautysh",
  "mypy",
  "debugpy",
  "yaml-language-server",
  "typescript-language-server",
  "html-lsp",
}

local conditionals = {
  arduino = "arduino-language-server",
  ["arduino-cli"] = "arduino-language-server",
  rustc = "rust-analyzer",
  javac = "jdtls",
  tex = "texlab",
  pdflatex = "texlab",
  docker = "dockerfile-language-server",
  cmake = "cmake-language-server",
}

for exe, ls in pairs(conditionals) do
  if vim.fn.executable(exe) ~= 0 then
    table.insert(M.mason_packages, ls)
  end
end

return M
