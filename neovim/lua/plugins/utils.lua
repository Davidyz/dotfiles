M = {}

M.mason_packages = {
  "basedpyright",
  -- "pylsp",
  "bash-language-server",
  "clang-format",
  "clangd",
  "clangd",
  "debugpy",
  "editorconfig-checker",
  "html-lsp",
  "jsonls",
  "lua-language-server",
  "prettierd",
  "ruff",
  "shellcheck",
  "shfmt",
  "stylua",
  "taplo",
  "tree-sitter-cli",
  "vim-language-server",
  "yaml-language-server",
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
