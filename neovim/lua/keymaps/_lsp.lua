if vim.fn.exists("g:vscode") ~= 0 then
  return
end

local lspkind = require("lspkind")
lspkind.init({
  mode = "symbol_text",
  maxwidth = function()
    return math.floor(vim.o.columns * 0.3)
  end,
  ellipsis_char = "…",
  preset = "codicons",
})
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
      return telescope.lsp_workspace_symbols(opts)
    end)
    -- Renames all references to the symbol under the cursor
    bufmap("n", "<Leader>r", vim.lsp.buf.rename)

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
    local select_opts = { behavior = cmp.SelectBehavior.Select }

    ---@type cmp.ConfigSchema
    local cmp_config = {
      snippet = {
        expand = function(args)
          vim.snippet.expand(args.body)
        end,
      },
      sources = {
        {
          name = "lazydev",
          group_index = 0, -- set group index to 0 to skip loading LuaLS completions
        },
        { name = "nvim_lsp", keyword_length = 1, priority = 9 },
        { name = "path", priority = 10 },
        { name = "buffer", keyword_length = 2, priority = 3 },
        { name = "snippets", keyword_length = 2 },
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

          item = lspkind.cmp_format()(entry, item)
          if color_item.abbr_hl_group then
            item.kind_hl_group = color_item.abbr_hl_group
            item.kind = color_item.abbr
            return item
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

        ["<Tab>"] = cmp.mapping(function(fallback)
          local col = vim.fn.col(".") - 1
          if cmp.visible() then
            cmp.select_next_item(select_opts)
          elseif col == 0 or vim.fn.getline("."):sub(col, col):match("%s") then
            fallback()
          elseif vim.snippet.active({ direction = 1 }) then
            vim.schedule(function()
              vim.snippet.jump(1)
            end)
          else
            cmp.complete()
          end
        end, { "i", "s" }),

        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item(select_opts)
          elseif vim.snippet.active({ direction = -1 }) then
            vim.schedule(function()
              vim.snippet.jump(-1)
            end)
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
