return {
  {
    "kevinhwang91/nvim-ufo",
    dependencies = {
      "kevinhwang91/promise-async",
      "nvim-treesitter/nvim-treesitter",
    },
    cond = require("_utils").no_vscode,
    init = function()
      vim.o.foldenable = true
      vim.o.foldlevel = 99
      vim.o.foldlevelstart = 99
      vim.o.foldcolumn = "0"
    end,
    config = function(_, opts)
      local ufo = require("ufo")
      ufo.setup(opts)
      vim.api.nvim_set_hl(0, "UfoCursorFoldedLine", { link = "CursorLine" })
      vim.api.nvim_set_hl(0, "UfoPreviewBg", { link = "FzfLuaPreviewBorder" })
      vim.api.nvim_set_hl(0, "UfoPreviewWinBar", { link = "FzfLuaPreviewBorder" })
      vim.api.nvim_set_hl(0, "UfoFoldedBg", { link = "CursorLine" })
      vim.keymap.set("n", "P", function()
        require("ufo.preview"):peekFoldedLinesUnderCursor()
      end, { noremap = true, desc = "Peek inside fold." })
      vim.keymap.set("n", "<BS>", "za", { noremap = true, desc = "Toggle fold." })
      vim.keymap.set(
        "n",
        "[f",
        ufo.goPreviousClosedFold,
        { noremap = true, desc = "Previous fold." }
      )
      vim.keymap.set(
        "n",
        "]f",
        ufo.goNextClosedFold,
        { noremap = true, desc = "Next fold." }
      )
    end,

    opts = {
      preview = {
        win_config = { winhighlight = "Normal:FzfLuaPreviewBorder", winblend = 0 },
      },
      fold_virt_text_handler = function(virt_text, lnum, end_lnum, width, truncate)
        local result = {}
        local _end = end_lnum - 1
        local final_text =
          vim.trim(vim.api.nvim_buf_get_text(0, _end, 0, _end, -1, {})[1])
        local suffix = final_text:format(end_lnum - lnum)
        local suffix_width = vim.fn.strdisplaywidth(suffix)
        local target_width = width - suffix_width
        local cur_width = 0
        for _, chunk in ipairs(virt_text) do
          local chunk_text = chunk[1]
          local chunk_width = vim.fn.strdisplaywidth(chunk_text)
          if target_width > cur_width + chunk_width then
            table.insert(result, chunk)
          else
            chunk_text = truncate(chunk_text, target_width - cur_width)
            local hl_group = chunk[2]
            table.insert(result, { chunk_text, hl_group })
            chunk_width = vim.fn.strdisplaywidth(chunk_text)
            -- str width returned from truncate() may less than 2nd argument, need padding
            if cur_width + chunk_width < target_width then
              suffix = suffix .. (" "):rep(target_width - cur_width - chunk_width)
            end
            break
          end
          cur_width = cur_width + chunk_width
        end
        table.insert(result, { "   ", "NonText" })
        table.insert(result, { suffix, "TSPunctBracket" })
        table.insert(result, {
          ("\t\t %d"):format(end_lnum - lnum),
          "Comment",
        })
        return result
      end,
      provider_selector = function(bufnum, _, _)
        if vim.bo.bt == "nofile" then
          return ""
        end

        if
          #vim.lsp.get_clients({
            bufnr = bufnum,
            method = vim.lsp.protocol.Methods.textDocument_foldingRange,
          }) > 0
        then
          return { "lsp", "treesitter" }
        end
        return { "treesitter", "indent" }
      end,
    },
    event = { "FileType" },
  },
}
