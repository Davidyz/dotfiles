if vim.fn.exists("g:vscode") ~= 0 then
  return
end

vim.o.pumheight = math.floor(vim.o.lines / 4)

vim.keymap.del({ "n" }, "gri")
vim.keymap.del({ "n", "x" }, "gra")
vim.keymap.del({ "n" }, "grn")
vim.keymap.del({ "n" }, "grr")
vim.keymap.del({ "n" }, "grt")
pcall(vim.keymap.del, { "n" }, "<C-s>")

local bufmap = function(mode, lhs, rhs, opts)
  local curr_buf = vim.api.nvim_get_current_buf()
  opts = opts or { buffer = curr_buf }

  if opts.buffer == nil then
    opts.buffer = curr_buf
  end
  vim.keymap.set(mode, lhs, rhs, opts)
end

local fzf = require("fzf-lua")
local actions = require("fzf-lua.actions")
local path = require("fzf-lua.path")

vim.api.nvim_create_autocmd("LspAttach", {
  desc = "LSP actions",
  callback = function(args)
    if vim.lsp.get_client_by_id(args.data.client_id).name == "vectorcode_server" then
      return
    end
    local opts = {
      sync = false,
      jump1 = true,
      jump1_action = function(selected, opts)
        if #selected == 0 then
          return
        end
        local entry = path.entry_to_file(selected[1], opts, false)
        local uri = vim.uri_from_fname(entry.path) or vim.uri_from_bufnr(entry.bufnr)
        if uri == nil then
          return
        end
        for _, tab in ipairs(vim.api.nvim_list_tabpages()) do
          for _, win in ipairs(vim.api.nvim_tabpage_list_wins(tab)) do
            if vim.uri_from_bufnr(vim.api.nvim_win_get_buf(win)) == uri then
              vim.api.nvim_set_current_win(win)
              if entry.line > 0 or entry.col > 0 then
                pcall(
                  vim.api.nvim_win_set_cursor,
                  win,
                  { math.max(1, entry.line), math.max(1, entry.col) - 1 }
                )
              end
              return
            end
          end
        end
        return actions.file_tabedit(selected, opts)
      end,
      unique_line_items = true,
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
          function(client, _)
            return vim.tbl_deep_extend(
              "force",
              vim.lsp.util.make_position_params(orig_win, client.offset_encoding),
              { newName = input or orig_name }
            )
          end,
          nil,
          function()
            vim.notify("Rename is not supported by the current language server.")
          end
        )
      end)
    end, { desc = "LSP [r]ename [v]ariable." })

    -- Move to the previous diagnostic
    bufmap("n", "[d", function()
      vim.diagnostic.jump({ pos = vim.api.nvim_win_get_cursor(0), count = -1 })
    end, { desc = "Previous diagnostic." })

    -- Move to the next diagnostic
    bufmap("n", "]d", function()
      vim.diagnostic.jump({ pos = vim.api.nvim_win_get_cursor(0), count = 1 })
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
