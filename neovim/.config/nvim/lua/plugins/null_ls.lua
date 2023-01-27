return function()
  local null_ls = require("null-ls")
  local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

  null_ls.setup({
    sources = {
      null_ls.builtins.formatting.stylua.with({
        extra_args = { "--indent-type", "Spaces", "--indent-width", "2" },
      }),
      null_ls.builtins.code_actions.gitsigns,
      null_ls.builtins.formatting.black,
      null_ls.builtins.formatting.clang_format,
      null_ls.builtins.formatting.beautysh,
      null_ls.builtins.formatting.latexindent,
      -- null_ls.builtins.formatting.jq,
      null_ls.builtins.formatting.jq.with({
        extra_args = { "--indent", tostring(vim.bo.sw) },
      }),
      null_ls.builtins.diagnostics.flake8,
      null_ls.builtins.diagnostics.mypy,
      null_ls.builtins.diagnostics.clang_check,
    },
    -- you can reuse a shared lspconfig on_attach callback here
    on_attach = function(client, bufnr)
      if client.supports_method("textDocument/formatting") then
        vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
        vim.api.nvim_create_autocmd("BufWritePre", {
          group = augroup,
          buffer = bufnr,
          callback = function()
            -- on 0.8, you should use vim.lsp.buf.format({ bufnr = bufnr }) instead
            vim.lsp.buf.format({ bufnr = bufnr })
          end,
        })
      end
    end,
  })
end
