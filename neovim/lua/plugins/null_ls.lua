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
      null_ls.builtins.formatting.ruff_format,
      null_ls.builtins.formatting.clang_format.with({
        filetypes = { "c", "cpp", "arduino" },
      }),
      null_ls.builtins.formatting.cmake_format,
      null_ls.builtins.formatting.beautysh.with({
        extra_args = { "-i", tostring(vim.bo.sts) },
      }),
      null_ls.builtins.formatting.latexindent.with({
        filetypes = { "tex", "bib" },
        extra_args = {
          "-m",
          '-y="modifyLineBreaks:textWrapOptions:columns:88",modifyLineBreaks:textWrapOptions:perCodeBlockBasis:1,modifyLineBreaks:textWrapOptions:all:1,modifyLineBreaks:removeParagraphLineBreaks:all:1,',
        },
      }),
      null_ls.builtins.formatting.jq,
      null_ls.builtins.formatting.isort,
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
