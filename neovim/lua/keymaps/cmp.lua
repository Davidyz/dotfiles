local cmp = require("cmp")
local compare = require("cmp.config.compare")

local select_opts = { behavior = cmp.SelectBehavior.Select }
---@type cmp.ConfigSchema
local cmp_config = {
  performance = { fetching_timeout = 2000 },
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
    {
      name = "async_path",
      priority = 10,
      option = { trailing_slash = true },
    },
    { name = "buffer", keyword_length = 2, priority = 3 },
    {
      name = "cmp_yanky",
      option = { onlyCurrentFiletype = false },
      keyword_length = 2,
    },
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
    { name = "codicons", keyword_length = 2, priority = 4 },
  },
  sorting = {
    priority_weight = 1,
    comparators = {
      compare.exact,
      compare.score,
      compare.recently_used,
      compare.locality,
      require("cmp-under-comparator").under,
      compare.order,
      compare.offset,
      compare.kind,
      compare.sort_text,
    },
  },
  window = {},
  formatting = {
    fields = { "abbr", "kind" },
    expandable_indicator = true,
    format = function(entry, item)
      local color_item = require("nvim-highlight-colors").format(
        entry,
        { kind = item.kind, abbr = item.abbr }
      )
      if entry.source.name == "cmp_yanky" then
        item.kind = "Clipboard"
      end
      item.kind = (require("_utils").codicons[item.kind] or "") .. (item.kind or "")

      if color_item.abbr_hl_group then
        item.kind_hl_group = color_item.abbr_hl_group
        item.kind = color_item.abbr
        return item
      end

      local highlights_info = require("colorful-menu").cmp_highlights(entry)
      if highlights_info ~= nil then
        item.abbr_hl_group = highlights_info.highlights
        item.abbr = highlights_info.text
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
        fallback()
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
    ["<C-x>"] = require("minuet").make_cmp_map(),
    -- ["<C-x>"] = cmp.mapping(
    --   cmp.mapping.complete({
    --     config = {
    --       sources = cmp.config.sources({
    --         { name = "cmp_ai" },
    --       }),
    --     },
    --   }),
    --   { "i" }
    -- ),
  },
}
return cmp_config
