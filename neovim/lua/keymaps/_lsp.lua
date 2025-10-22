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
    local snacks = require("snacks")
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
      return snacks.picker.lsp_definitions()
    end, { desc = "Goto definition." })

    bufmap("n", "gD", function()
      return snacks.picker.lsp_type_definitions()
    end, { desc = "Goto type definition." })

    bufmap("n", "gi", function()
      return snacks.picker.lsp_implementations()
    end, { desc = "Goto implementations." })

    bufmap("n", "gr", function()
      return snacks.picker.lsp_references()
    end, { desc = "LSP reference." })
    bufmap({ "i", "n" }, "<C-f>", function()
      return snacks.picker.lsp_symbols()
    end, { desc = "Document symbols." })
    bufmap({ "i", "n" }, "<C-S-f>", function()
      return snacks.picker.lsp_workspace_symbols({ live = true })
    end, { desc = "Workspace symbols." })

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
