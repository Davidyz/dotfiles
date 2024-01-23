local utils = require("_utils")

return function()
  local null_ls = require("null-ls")
  local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

  null_ls.setup({
    border = "double",
    sources = {
      null_ls.builtins.formatting.stylua.with({
        extra_args = {
          "--indent-type",
          "Spaces",
          "--indent-width",
          "2",
          "--column-width",
          tostring(88),
        },
      }),
      null_ls.builtins.code_actions.gitsigns,
      --null_ls.builtins.formatting.black,
      --null_ls.builtins.formatting.autopep8.with({
      --extra_args = { "--max-line-length", tostring(utils.line_length() or 80) },
      --}),
      --null_ls.builtins.formatting.autoflake,
      null_ls.builtins.formatting.ruff_format,
      null_ls.builtins.formatting.clang_format,
      null_ls.builtins.formatting.cmake_format,
      null_ls.builtins.formatting.beautysh,
      null_ls.builtins.formatting.latexindent,
      null_ls.builtins.formatting.jq,
      null_ls.builtins.formatting.isort,
      --null_ls.builtins.diagnostics.flake8.with({
      --extra_args = {
      --"--max-line-length",
      --tostring(utils.line_length() or 88),
      --},
      --}),
      --null_ls.builtins.diagnostics.mypy,
      null_ls.builtins.diagnostics.ruff,
      null_ls.builtins.diagnostics.clang_check,
    },
    -- you can reuse a shared lspconfig on_attach callback here
    on_attach = function(client, bufnr)
      if client.supports_method("textDocument/formatting") then
        vim.api.nvim_clear_autocmds({
          group = augroup,
          buffer = bufnr,
        })
        vim.api.nvim_create_autocmd("BufWritePre", {
          group = augroup,
          buffer = bufnr,
          callback = function()
            vim.lsp.buf.format({
              bufnr = bufnr,
              async = false,
            })
          end,
        })
      end
    end,
  })
end
