if vim.fn.exists("g:vscode") ~= 0 then
  return
end
local cmp_kinds = {
  Text = "  ",
  Method = "  ",
  Function = "  ",
  Constructor = "  ",
  Field = "  ",
  Variable = "  ",
  Class = "  ",
  Interface = "  ",
  Module = "  ",
  Property = "  ",
  Unit = "  ",
  Value = "  ",
  Enum = "  ",
  Keyword = "  ",
  Snippet = "  ",
  Color = "  ",
  File = "  ",
  Reference = "  ",
  Folder = "  ",
  EnumMember = "  ",
  Constant = "  ",
  Struct = "  ",
  Event = "  ",
  Operator = "  ",
  TypeParameter = "  ",
}

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

    -- Jump to the definition
    bufmap("n", "gd", function(ctx, opts)
      opts = opts or {}
      opts.jump_type = "tab"
      if has_telescope then
        return telescope.lsp_definitions(opts)
      end
      return vim.lsp.buf.definition({ reuse_win = false })
    end)

    bufmap("n", "ls", function(ctx, opts)
      if has_telescope then
        return telescope.lsp_document_symbols(opts)
      end
    end)

    -- Jump to declaration
    bufmap("n", "gD", vim.lsp.buf.declaration)

    -- Lists all the implementations for the symbol under the cursor
    bufmap("n", "gi", function(ctx, opts)
      opts = opts or {}
      opts.jump_type = "tab"
      if has_telescope then
        return telescope.lsp_implementations(opts)
      end
      return vim.lsp.buf.implementation()
    end)

    -- Jumps to the definition of the type symbol
    bufmap("n", "go", vim.lsp.buf.type_definition)

    -- Lists all the references
    bufmap("n", "gr", function(ctx, opts)
      opts = opts or {}
      opts.jump_type = "tab"
      if has_telescope then
        return telescope.lsp_references(opts)
      else
        return vim.lsp.buf.references(ctx, opts)
      end
    end)

    -- Displays a function's signature information
    -- bufmap("n", "<C-k>", vim.lsp.buf.signature_help)

    -- Renames all references to the symbol under the cursor
    bufmap("n", "<Leader>r", vim.lsp.buf.rename)

    -- Selects a code action available at the current cursor position
    --bufmap("n", "<Leader>a", vim.lsp.buf.code_action)

    -- Show diagnostics in a floating window
    bufmap("n", "gl", vim.diagnostic.open_float)

    -- Move to the previous diagnostic
    bufmap("n", "[d", function()
      vim.diagnostic.goto_prev({ float = false })
    end)

    -- Move to the next diagnostic
    bufmap("n", "]d", function()
      vim.diagnostic.goto_next({ float = false })
    end)

    local cmp = require("cmp")
    local compare = require("cmp.config.compare")
    local luasnip = require("luasnip")
    local select_opts = { behavior = cmp.SelectBehavior.Insert }

    ---@type cmp.ConfigSchema
    local cmp_config = {
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      sources = {
        {
          name = "lazydev",
          group_index = 0, -- set group index to 0 to skip loading LuaLS completions
        },
        { name = "nvim_lsp", keyword_length = 1, priority = 9 },
        -- { name = "nvim_lua", priority = 10 },
        { name = "path", priority = 10 },
        { name = "buffer", keyword_length = 2, priority = 3 },
        { name = "luasnip", keyword_length = 2 },
        { name = "nvim_lsp_signature_help" },
        { name = "zsh" },
        { name = "emoji" },
        {
          name = "latex_symbols",
          option = {
            strategy = 0, -- mixed
          },
        },
      },
      sorting = {
        priority_weight = 1,
        comparators = {
          compare.recently_used,
          compare.locality,
          compare.score,
          compare.order,
        },
      },
      window = {},
      formatting = {
        fields = { "abbr", "menu", "kind" },
        expandable_indicator = true,
        format = function(entry, item)
          local color_item = require("nvim-highlight-colors").format(
            entry,
            { kind = item.kind, abbr = item.abbr }
          )
          item = require("lspkind").cmp_format({
            mode = "text",
            maxwidth = function()
              return math.floor(vim.o.columns * 0.3)
            end,
            ellipsis_char = "…",
          })(entry, item)
          if color_item.abbr_hl_group then
            item.kind_hl_group = color_item.abbr_hl_group
            item.kind = color_item.abbr
          end
          if
            item.menu
            and #item.abbr + #item.kind + #item.menu > math.floor(vim.o.columns * 0.3)
          then
            -- truncate long menu items
            item.menu = string.sub(
              item.menu,
              1,
              math.floor(vim.o.columns * 0.3) - #item.abbr - #item.kind
            ) .. "…"
          end
          item.kind = (cmp_kinds[item.kind] or "") .. item.kind
          return item
        end,
      },
      view = { entries = { name = "custom" } },
      mapping = {
        ["<CR>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.confirm({
              behavior = cmp.ConfirmBehavior.Replace,
              select = true,
            })
          else
            local cr = vim.api.nvim_replace_termcodes("<cr>", true, true, true)
            vim.api.nvim_feedkeys(cr, "n", false)
          end
        end),

        ["<Up>"] = cmp.mapping.select_prev_item(select_opts),
        ["<Down>"] = cmp.mapping.select_next_item(select_opts),

        ["<C-u>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-d>"] = cmp.mapping(function(fallback)
          if luasnip.jumpable(1) then
            luasnip.jump(1)
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<C-b>"] = cmp.mapping(function(fallback)
          if luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<Tab>"] = cmp.mapping(function(fallback)
          local col = vim.fn.col(".") - 1

          if cmp.visible() then
            cmp.select_next_item(select_opts)
          elseif col == 0 or vim.fn.getline("."):sub(col, col):match("%s") then
            fallback()
          elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
          else
            cmp.complete()
          end
        end, { "i", "s" }),

        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item(select_opts)
          else
            fallback()
          end
        end, { "i", "s" }),
      },
    }

    cmp.setup(cmp_config)

    cmp.setup.filetype({ "autohotkey" }, {
      sources = { { name = "autohotkey" } },
    })

    cmp.setup.cmdline({ "/", "?" }, {
      mapping = cmp.mapping.preset.cmdline(),
      sources = {
        { name = "buffer" },
      },
    })
    cmp.setup.cmdline(":", {
      mapping = cmp.mapping.preset.cmdline(),
      sources = cmp.config.sources({
        { name = "path" },
      }, {
        { name = "cmdline" },
      }),
    })
  end,
})
