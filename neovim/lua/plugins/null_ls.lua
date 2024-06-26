local utils = require("_utils")

return function()
  local null_ls = require("null-ls")
  local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

  local mason_config = {
    border = "double",
    sources = {
      null_ls.builtins.formatting.isort,
      null_ls.builtins.formatting.stylua,
      null_ls.builtins.formatting.prettierd,
      null_ls.builtins.code_actions.gitsigns,
      null_ls.builtins.formatting.cmake_format,
      null_ls.builtins.formatting.shfmt.with({
        filetypes = { "sh", "bash", "zsh" },
        extra_args = { "-i", vim.bo.sts },
      }),
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
  }

  if vim.fn.executable("black") == 1 then
    mason_config.sources = vim.tbl_extend(
      "keep",
      mason_config.sources,
      { null_ls.builtins.formatting.black }
    )
  end
  null_ls.setup(mason_config)
end
