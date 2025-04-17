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
  callback = function(args)
    if vim.lsp.get_client_by_id(args.data.client_id).name == "vectorcode_server" then
      return
    end
    local fzf = require("fzf-lua")

    local actions = require("fzf-lua").actions
    local opts = {
      sync = false,
      jump1 = true,
      jump1_action = function(selected, opts)
        -- jump if in the same file, new tab otherwise
        local path = string.gsub(selected[1], ":.*", "")
        local action
        if vim.uri_from_fname(path) == vim.uri_from_bufnr(0) then
          action = actions.file_edit
        else
          action = actions.file_tabedit
        end
        action(selected, opts)
      end,
    }
    bufmap("n", "gd", function()
      return fzf.lsp_definitions(opts)
    end, { desc = "Goto definition." })

    bufmap("n", "gD", function()
      return fzf.lsp_typedefs(opts)
    end, { desc = "Goto type definition." })

    bufmap("n", "gi", function()
      return fzf.lsp_implementations(opts)
    end, { desc = "Goto implementations." })

    bufmap("n", "gr", function()
      return fzf.lsp_references(opts)
    end, { desc = "LSP reference." })
    bufmap({ "i", "n" }, "<C-f>", function()
      return fzf.lsp_document_symbols()
    end, { desc = "Document symbols." })
    bufmap({ "i", "n" }, "<C-S-f>", function()
      return fzf.lsp_live_workspace_symbols()
    end, { desc = "Workspace symbols." })

    bufmap("n", "<Leader>rv", function()
      local orig_win = vim.api.nvim_get_current_win()
      local orig_buf = vim.api.nvim_win_get_buf(orig_win)
      local orig_name = vim.fn.expand("<cword>")
      vim.ui.input({ prompt = "New name", default = orig_name }, function(input)
        vim.lsp.buf_request(
          orig_buf,
          vim.lsp.protocol.Methods.textDocument_rename,
          vim.tbl_deep_extend(
            "force",
            vim.lsp.util.make_position_params(orig_win),
            { newName = input or orig_name }
          ),
          nil,
          function()
            vim.notify("Rename is not supported by the current language server.")
          end
        )
      end)
    end, { desc = "LSP [r]ename [v]ariable." })

    -- Move to the previous diagnostic
    bufmap("n", "[d", function()
      vim.diagnostic.get_prev({ float = false })
    end, { desc = "Previous diagnostic." })

    -- Move to the next diagnostic
    bufmap("n", "]d", function()
      vim.diagnostic.get_next({ float = false })
    end, { desc = "Next diagnostic." })

    bufmap("n", "<Leader>ii", function()
      local bufnr = vim.api.nvim_get_current_buf()
      return vim.lsp.inlay_hint.enable(
        not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }),
        { bufnr = bufnr }
      )
    end, { desc = "Toggle inlay hint for current buffer" })
  end,
})
