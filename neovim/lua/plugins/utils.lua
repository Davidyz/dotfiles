M = {}

M.mason_packages = {
  "clang-format",
  "shellcheck",
  "clangd",
  "lua-language-server",
  "stylua",
  "vim-language-server",
  "bash-language-server",
  "ruff",
  "basedpyright",
  "jsonls",
  "clangd",
  "debugpy",
  "shfmt",
  "prettierd",
  "yaml-language-server",
  "html-lsp",
  "taplo",
  "editorconfig-checker",
  "tree-sitter-cli",
}

local conditionals = {
  arduino = "arduino-language-server",
  ["arduino-cli"] = "arduino-language-server",
  rustc = "rust-analyzer",
  javac = "jdtls",
  tex = "texlab",
  pdflatex = { "texlab", "latexindent" },
  docker = { "dockerfile-language-server", "docker-compose-language-service" },
  cmake = { "cmakelang", "cmake-language-server" },
  node = { "typescript-language-server" },
}

if vim.fn.executable("java") then
  local output = vim.fn.execute("!java -version") or ""
  local java_ver_num = string.match(output, "build (%d+)") or 0
  if tonumber(java_ver_num) > 11 then
    table.insert(M.mason_packages, "ltex-ls")
  end
end

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
