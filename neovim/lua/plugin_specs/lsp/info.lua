local api = vim.api
local diag = vim.diagnostic

---@module "lazy"

---@type LazySpec[]
return {
  {
    "xzbdmw/colorful-menu.nvim",
    opts = {},
  },
  {
    "SmiteshP/nvim-navic",
    opts = {
      lsp = { auto_attach = true, preference = { "ty" } },
      icons = require("_utils").codicons,
      click = true,
    },
    event = "LspAttach",
    cond = require("_utils").no_vscode,
  },
  {
    "Wansmer/symbol-usage.nvim",
    event = "LspAttach",
    opts = function()
      local function h(name)
        return api.nvim_get_hl(0, { name = name })
      end

      -- hl-groups can have any name
      api.nvim_set_hl(
        0,
        "SymbolUsageRounding",
        { fg = h("CursorLine").bg, italic = true }
      )
      api.nvim_set_hl(
        0,
        "SymbolUsageContent",
        { bg = h("CursorLine").bg, fg = h("Comment").fg, italic = true }
      )
      api.nvim_set_hl(
        0,
        "SymbolUsageRef",
        { fg = h("Function").fg, bg = h("CursorLine").bg, italic = true }
      )
      api.nvim_set_hl(
        0,
        "SymbolUsageDef",
        { fg = h("Type").fg, bg = h("CursorLine").bg, italic = true }
      )
      api.nvim_set_hl(
        0,
        "SymbolUsageImpl",
        { fg = h("@keyword").fg, bg = h("CursorLine").bg, italic = true }
      )

      local function text_format(symbol)
        local res = {}

        local round_start = { "", "SymbolUsageRounding" }
        local round_end = { "", "SymbolUsageRounding" }

        -- Indicator that shows if there are any other symbols in the same line
        local stacked_functions_content = symbol.stacked_count > 0
            and ("+%s"):format(symbol.stacked_count)
          or ""

        if symbol.references then
          local usage = symbol.references <= 1 and "usage" or "usages"
          local num = symbol.references == 0 and "no" or symbol.references
          table.insert(res, round_start)
          table.insert(res, { "󰌹  ", "SymbolUsageRef" })
          table.insert(res, { ("%s %s"):format(num, usage), "SymbolUsageContent" })
          table.insert(res, round_end)
        end

        if symbol.definition then
          if #res > 0 then
            table.insert(res, { " ", "NonText" })
          end
          table.insert(res, round_start)
          table.insert(res, { "󰳽  ", "SymbolUsageDef" })
          table.insert(res, { symbol.definition .. " defs", "SymbolUsageContent" })
          table.insert(res, round_end)
        end

        if symbol.implementation then
          if #res > 0 then
            table.insert(res, { " ", "NonText" })
          end
          table.insert(res, round_start)
          table.insert(res, { "󰡱  ", "SymbolUsageImpl" })
          table.insert(res, { symbol.implementation .. " impls", "SymbolUsageContent" })
          table.insert(res, round_end)
        end

        if stacked_functions_content ~= "" then
          if #res > 0 then
            table.insert(res, { " ", "NonText" })
          end
          table.insert(res, round_start)
          table.insert(res, { "  ", "SymbolUsageImpl" })
          table.insert(res, { stacked_functions_content, "SymbolUsageContent" })
          table.insert(res, round_end)
        end

        return res
      end
      ---@module "symbol-usage"
      ---@type UserOpts|{}
      return {
        text_format = text_format,
        definition = { enabled = true },
        implementation = { enabled = true },
        symbol_filter = function(ctx)
          return function(symbol)
            if ctx.method == "textDocument/references" then
              return string.find(symbol.uri, "tests") == nil
            else
              return true
            end
          end
        end,
      }
    end,
  },
  {
    "j-hui/fidget.nvim",
    event = "LspAttach",
    version = "*",
    opts = function()
      return {
        notification = {
          window = {
            normal_hl = "FidgetNormal",
            winblend = 50,
            align = "bottom",
            x_padding = 0,
            border = "solid",
          },
          view = { stack_upwards = false },
        },
      }
    end,
    config = function(_, opts)
      require("fidget").setup(opts)
      local comment_hl = api.nvim_get_hl(0, { name = "Comment" })
      local float_border = api.nvim_get_hl(0, { name = "FloatBorder" })
      api.nvim_set_hl(
        0,
        "FidgetNormal",
        { fg = comment_hl.fg, guifg = comment_hl.guifg, bg = float_border.bg }
      )
    end,
    cond = require("_utils").no_vscode,
  },
  {
    "hedyhli/outline.nvim",
    cond = require("_utils").no_vscode,
    cmd = { "Outline", "OutlineOpen" },
    keys = {
      { "<leader>o", ":Outline<CR>", desc = "Toggle outline" },
    },
    opts = function()
      local opts = { symbols = { icons = {} } }
      for k, v in pairs(require("_utils").codicons) do
        opts.symbols.icons[k] = { icon = v }
      end
      return opts
    end,
    init = function()
      api.nvim_create_autocmd("BufEnter", {
        nested = true,
        callback = function()
          if #api.nvim_list_wins() == 1 and vim.bo.filetype == "Outline" then
            vim.cmd("quit")
          end
        end,
      })
    end,
  },
  {
    "lewis6991/hover.nvim",
    opts = {
      providers = {
        "hover.providers.lsp",
        "hover.providers.man",
        "hover.providers.dap",
        "hover.providers.diagnostic",
        "hover.providers.fold_preview",
        "hover.providers.highlight",
        "plugin_extras.hover_peek",
      },
      preview_opts = { border = "solid" },
      preview_window = false,
      title = true,
      mouse_providers = {
        "LSP",
      },
      mouse_delay = 1000,
    },
    config = function(_, opts)
      require("hover").config(opts)
    end,
    keys = {
      {
        "K",
        function()
          require("hover").open({})
        end,
        desc = "Trigger hover.",
        mode = "n",
        noremap = true,
      },
      {
        "W",
        "<cmd>wincmd w<cr>",
        desc = "Focus floating window",
        mode = "n",
        noremap = true,
      },
    },
  },

  {
    "rachartier/tiny-inline-diagnostic.nvim",
    event = { "LspAttach" },
    init = function()
      diag.config({
        virtual_text = false,
      })
    end,
    main = "tiny-inline-diagnostic",
    cond = require("_utils").no_vscode,
    opts = {
      preset = "nonerdfont",
      options = {
        multiple_diag_under_cursor = true,
        show_source = true,
      },
    },
  },
  {

    "saecki/live-rename.nvim",
    opts = { hl = { others = "LspReferenceText", current = "LspReferenceText" } },
    keys = {
      {
        "<Leader>rv",
        function()
          return require("live-rename").rename({ insert = true })
        end,
        mode = { "n" },
        desc = "LSP rename",
      },
    },
  },
  {
    "Davidyz/inlayhint-filler.nvim",
    event = "LspAttach",
    ---@module "inlayhint-filler"
    ---@type InlayHintFillerOpts
    opts = {
      blacklisted_servers = {},
      force = function(ctx)
        if vim.bo[ctx.bufnr].filetype == "rust" then
          return true
        end
        return false
      end,
      eager = function(ctx)
        return vim.bo[ctx.bufnr].filetype == "rust"
      end,
    },
    keys = {
      {
        "<Leader>if",
        function()
          if vim.lsp.inlay_hint.apply_text_edits ~= nil then
            return vim.lsp.inlay_hint.apply_text_edits({ bufnr = 0 })
          end
          require("inlayhint-filler").fill()
        end,
        mode = { "n", "v" },
        desc = "[I]nlayhint [f]ill",
      },
    },
  },
}
