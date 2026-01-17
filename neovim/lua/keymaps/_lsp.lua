local api = vim.api
local fn = vim.fn
local lsp = vim.lsp

local utils = require("keymaps.utils")
if fn.exists("g:vscode") ~= 0 then
  return
end
vim.o.pumheight = math.floor(vim.o.lines / 4)

vim.keymap.del({ "n" }, "gri")
vim.keymap.del({ "n", "x" }, "gra")
vim.keymap.del({ "n" }, "grn")
vim.keymap.del({ "n" }, "grr")
vim.keymap.del({ "n" }, "grt")
pcall(vim.keymap.del, { "n" }, "<C-s>")

local function make_mapper(bufnr)
  return function(mode, lhs, rhs, opts)
    opts = opts or { buffer = bufnr }

    if opts.buffer == nil then
      opts.buffer = bufnr
    end
    vim.keymap.set(mode, lhs, rhs, opts)
  end
end

api.nvim_create_autocmd("LspAttach", {
  desc = "LSP actions",
  callback = function(args)
    local bufmap = make_mapper(args.buf)
    local snacks = require("snacks")
    if vim.bo.filetype == "codecompanion" then
      return
    end

    local opts = {
      unique_lines = true,
      include_current = true,
    }

    bufmap("n", "gd", function()
      return snacks.picker.lsp_definitions(opts)
    end, { desc = "Goto definition." })

    bufmap("n", "gD", function()
      return snacks.picker.lsp_type_definitions(opts)
    end, { desc = "Goto type definition." })

    bufmap("n", "gi", function()
      return snacks.picker.lsp_implementations(opts)
    end, { desc = "Goto implementations." })

    bufmap("n", "gr", function()
      return snacks.picker.lsp_references(opts)
    end, { desc = "LSP reference." })
    bufmap({ "i", "n" }, "<C-f>", function()
      return snacks.picker.lsp_symbols(opts)
    end, { desc = "Document symbols." })
    bufmap({ "i", "n" }, "<C-F>", function()
      return snacks.picker.lsp_workspace_symbols({ live = true, unique_lines = true })
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

    local inlay_hint_action = lsp.inlay_hint.action or lsp.inlay_hint.apply_action
    if inlay_hint_action then
      local mode = { "n", "v" }
      bufmap(mode, "<Leader>ie", function()
        inlay_hint_action("textEdits")
      end, { desc = "Apply text[E]dits" })

      bufmap(mode, "<Leader>ih", function()
        inlay_hint_action("hover", {}, nil)
      end, { desc = "Inlay hint [h]over" })

      bufmap(mode, "<Leader>il", function()
        if snacks.picker.lsp_inlay_hint_locations then
          return snacks.picker.lsp_inlay_hint_locations()
        end
        inlay_hint_action(function(hints, ctx, _)
          hints = vim
            .iter(hints)
            :filter(
              ---@param item lsp.InlayHint
              function(item)
                return type(item.label) == "table"
                  and vim.iter(item.label):any(
                    ---@param label lsp.InlayHintLabelPart
                    function(label)
                      return label.location ~= nil
                    end
                  )
              end
            )
            :totable()
          if #hints == 0 then
            return 0
          end

          snacks.picker.pick({
            items = vim
              .iter(hints)
              :map(
                ---@param hint lsp.InlayHint
                ---@return snacks.picker.Item[]
                function(hint)
                  ---@type snacks.picker.Item[]
                  local result = {}
                  vim.iter(hint.label):each(
                    ---@param label lsp.InlayHintLabelPart
                    function(label)
                      if label.location == nil then
                        return
                      end

                      local picker_pos = vim.tbl_deep_extend(
                        "force",
                        label.location,
                        { encoding = ctx.client.offset_encoding }
                      ) ---@cast picker_pos snacks.picker.lsp.Loc

                      local fname = vim.uri_to_fname(label.location.uri)
                      if
                        vim.iter(result):any(function(item)
                          return vim.deep_equal(item.loc, picker_pos)
                        end)
                      then
                        return
                      end
                      local idx = #result + 1
                      result[idx] = {
                        idx = idx,
                        score = 1,
                        text = label.value,
                        loc = picker_pos,
                        file = fname,
                      }
                    end
                  )
                  return result
                end
              )
              :flatten(1)
              :totable(),
            format = function(item, picker)
              return { { item.text, "Type" } }
            end,
            title = "InlayHint Locations",
            auto_confirm = true,
            sort = {},
          })
          return 1
        end, nil, nil)
      end, { desc = "Jump to location" })

      bufmap(mode, "<Leader>ic", function()
        inlay_hint_action("command")
      end, { desc = "Inlay hint [c]ommand" })

      bufmap(mode, "<Leader>iT", function()
        inlay_hint_action("tooltip")
      end, { desc = "[t]ooltips" })
    end
  end,
})
