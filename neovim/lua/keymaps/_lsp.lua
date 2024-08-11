if vim.fn.exists("g:vscode") ~= 0 then
  return
end

vim.o.pumheight = math.floor(vim.o.lines / 4)

local bufmap = function(mode, lhs, rhs)
  local opts = { buffer = true }
  vim.keymap.set(mode, lhs, rhs, opts)
end

vim.api.nvim_create_autocmd("LspAttach", {
  desc = "LSP actions",
  callback = function()
    -- Displays hover information about the symbol under the cursor
    local has_telescope, telescope = pcall(require, "telescope.builtin")

    bufmap("n", "gd", function(ctx, opts)
      opts = opts or {}
      opts.jump_type = "tab"
      return telescope.lsp_definitions(opts)
    end)

    bufmap("n", "gD", function(ctx, opts)
      opts = opts or {}
      opts.jump_type = "tab"
      return telescope.lsp_type_definitions(opts)
    end)

    bufmap("n", "gi", function(ctx, opts)
      opts = opts or {}
      opts.jump_type = "tab"
      return telescope.lsp_implementations(opts)
    end)

    bufmap("n", "gr", function(ctx, opts)
      opts = opts or {}
      opts.jump_type = "tab"
      return telescope.lsp_references(opts)
    end)
    bufmap({ "i", "n" }, "<C-f>", function(ctx, opts)
      return telescope.lsp_document_symbols(opts)
    end)
    bufmap({ "i", "n" }, "<C-S-f>", function(ctx, opts)
      return telescope.lsp_dynamic_workspace_symbols(opts)
    end)
    -- Renames all references to the symbol under the cursor
    bufmap("n", "<Leader>rv", vim.lsp.buf.rename)

    -- Move to the previous diagnostic
    bufmap("n", "[d", function()
      vim.diagnostic.goto_prev({ float = false })
    end)

    -- Move to the next diagnostic
    bufmap("n", "]d", function()
      vim.diagnostic.goto_next({ float = false })
    end)
  end,
})
