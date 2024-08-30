if vim.fn.exists("g:vscode") ~= 0 then
  return
end

vim.o.pumheight = math.floor(vim.o.lines / 4)

local bufmap = function(mode, lhs, rhs, opts)
  opts = opts or { buffer = true }
  if opts.buffer == nil then
    opts.buffer = true
  end
  vim.keymap.set(mode, lhs, rhs, opts)
end

vim.api.nvim_create_autocmd("LspAttach", {
  desc = "LSP actions",
  callback = function()
    -- Displays hover information about the symbol under the cursor
    local telescope = require("telescope.builtin")

    bufmap("n", "gd", function(_, opts)
      opts = opts or {}
      opts.jump_type = "tab"
      return telescope.lsp_definitions(opts)
    end, { desc = "Goto definition." })

    bufmap("n", "gD", function(_, opts)
      opts = opts or {}
      opts.jump_type = "tab"
      return telescope.lsp_type_definitions(opts)
    end, { desc = "Goto type definition." })

    bufmap("n", "gi", function(_, opts)
      opts = opts or {}
      opts.jump_type = "tab"
      return telescope.lsp_implementations(opts)
    end, { desc = "Goto implementations." })

    bufmap("n", "gr", function(_, opts)
      opts = opts or {}
      opts.jump_type = "tab"
      return telescope.lsp_references(opts)
    end, { desc = "LSP reference." })
    bufmap({ "i", "n" }, "<C-f>", function(_, opts)
      return telescope.lsp_document_symbols(opts)
    end, { desc = "Document symbols." })
    bufmap({ "i", "n" }, "<C-S-f>", function(_, opts)
      return telescope.lsp_dynamic_workspace_symbols(opts)
    end, { desc = "Workspace symbols." })

    -- Move to the previous diagnostic
    bufmap("n", "[d", function()
      vim.diagnostic.goto_prev({ float = false })
    end, { desc = "Previous diagnostic." })

    -- Move to the next diagnostic
    bufmap("n", "]d", function()
      vim.diagnostic.goto_next({ float = false })
    end, { desc = "Next diagnostic." })

    bufmap("n", "<Leader>i", function()
      local bufnr = vim.api.nvim_get_current_buf()
      return vim.lsp.inlay_hint.enable(
        not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }),
        { bufnr = bufnr }
      )
    end, { desc = "Toggle inlay hint for current buffer" })
  end,
})
