local api = vim.api
local fn = vim.fn
local lsp = vim.lsp

local utils = require("keymaps.utils")
if fn.exists("g:vscode") ~= 0 then
  return
end
local fzf_lua_jump_action = utils.fzf_lua_jump_action
vim.o.pumheight = math.floor(vim.o.lines / 4)

vim.keymap.del({ "n" }, "gri")
vim.keymap.del({ "n", "x" }, "gra")
vim.keymap.del({ "n" }, "grn")
vim.keymap.del({ "n" }, "grr")
vim.keymap.del({ "n" }, "grt")
pcall(vim.keymap.del, { "n" }, "<C-s>")

local bufmap = function(mode, lhs, rhs, opts)
  local curr_buf = api.nvim_get_current_buf()
  opts = opts or { buffer = curr_buf }

  if opts.buffer == nil then
    opts.buffer = curr_buf
  end
  vim.keymap.set(mode, lhs, rhs, opts)
end

api.nvim_create_autocmd("LspAttach", {
  desc = "LSP actions",
  callback = function(args)
    local fzf = require("fzf-lua")

    if vim.bo.filetype == "codecompanion" then
      return
    end

    local opts = {
      sync = false,
      jump1 = true,
      jump1_action = fzf_lua_jump_action,
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
      local orig_win = api.nvim_get_current_win()
      local orig_buf = api.nvim_win_get_buf(orig_win)
      local orig_name = fn.expand("<cword>")
      vim.ui.input({ prompt = "New name", default = orig_name }, function(input)
        local rename_method = lsp.protocol.Methods.textDocument_rename
        local clients = lsp.get_clients({
          bufnr = orig_buf,
          method = rename_method,
        })

        if #clients == 0 then
          vim.schedule_wrap(vim.notify)("There's no LSP client that supports renaming.")
          return
        end
        ---@param idx? integer
        ---@param client vim.lsp.Client
        local function do_rename(idx, client)
          if idx == nil or client == nil then
            vim.schedule_wrap(vim.notify)(
              "There's no LSP client that supports renaming."
            )
            return
          end
          client:request(
            rename_method,
            vim.tbl_deep_extend(
              "force",
              lsp.util.make_position_params(orig_win, client.offset_encoding),
              { newName = input or orig_name }
            ),
            function(err, result, context, config)
              if result ~= nil then
                local ok, _ =
                  pcall(lsp.util.apply_workspace_edit, result, client.offset_encoding)
                if ok then
                  return
                end
              end
              do_rename(next(clients, idx), client)
            end,
            orig_buf
          )
        end

        do_rename(next(clients))
      end)
    end, { desc = "LSP [r]ename [v]ariable." })

    -- Move to the previous diagnostic
    bufmap("n", "[d", function()
      vim.diagnostic.jump({ pos = api.nvim_win_get_cursor(0), count = -1 })
    end, { desc = "Previous diagnostic." })

    -- Move to the next diagnostic
    bufmap("n", "]d", function()
      vim.diagnostic.jump({ pos = api.nvim_win_get_cursor(0), count = 1 })
    end, { desc = "Next diagnostic." })

    bufmap("n", "<Leader>it", function()
      local bufnr = api.nvim_get_current_buf()
      return lsp.inlay_hint.enable(
        not lsp.inlay_hint.is_enabled({ bufnr = bufnr }),
        { bufnr = bufnr }
      )
    end, { desc = "[I]nlayhint [t]oggle" })
  end,
})
