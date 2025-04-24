return function(_, opts)
  vim.keymap.del("s", "<tab>", {})
  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = vim.tbl_deep_extend("force", opts or {}, {
    keymap = {
      ["<C-x>"] = {
        function(cmp)
          if package.loaded["minuet"] then
            cmp.show({ providers = { "minuet" } })
          end
        end,
      },
      ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
      ["<C-e>"] = { "hide", "fallback" },

      ["<Tab>"] = {
        function(cmp)
          local col = vim.fn.col(".") - 1
          if cmp.is_menu_visible() then
            return cmp.select_next()
          elseif cmp.snippet_active() then
            return cmp.accept()
          elseif col == 0 or vim.fn.getline("."):sub(col, col):match("%s") then
            return nil
          else
            return cmp.show()
          end
        end,
        "fallback",
      },
      ["<S-Tab>"] = { "select_prev", "fallback" },
      ["<Left>"] = { "snippet_backward", "fallback" },
      ["<Right>"] = { "snippet_forward", "fallback" },
      ["<CR>"] = {
        "accept",
        "fallback",
      },

      ["<Up>"] = { "select_prev", "fallback" },
      ["<Down>"] = { "select_next", "fallback" },
      ["<C-p>"] = { "select_prev", "fallback" },
      ["<C-n>"] = { "select_next", "fallback" },

      ["<C-b>"] = { "scroll_documentation_up", "fallback" },
      ["<C-f>"] = { "scroll_documentation_down", "fallback" },
    },
    cmdline = {
      completion = {
        menu = { auto_show = true },
        list = {
          selection = {
            preselect = false,
            auto_insert = true,
          },
        },
      },
      enabled = true,
      keymap = {
        ["<CR>"] = {
          function(cmp)
            if cmp.is_menu_visible() then
              return cmp.accept()
            end
          end,
          "fallback",
        },
        ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
        ["<C-e>"] = { "hide", "fallback" },

        ["<Tab>"] = {
          function(cmp)
            local col = vim.fn.col(".") - 1
            if cmp.is_menu_visible() then
              return cmp.select_next({ auto_insert = true, preselect = true })
            elseif col == 0 or vim.fn.getline("."):sub(col, col):match("%s") then
              return nil
            else
              return cmp.show()
            end
          end,
          "fallback",
        },
        ["<S-Tab>"] = { "snippet_backward", "select_prev", "fallback" },

        ["<Up>"] = { "fallback" },
        ["<Down>"] = { "fallback" },
        ["<Left>"] = { "fallback" },
        ["<Right>"] = { "fallback" },
        ["<C-p>"] = { "select_prev", "fallback" },
        ["<C-n>"] = { "select_next", "fallback" },

        ["<C-b>"] = { "scroll_documentation_up", "fallback" },
        ["<C-f>"] = { "scroll_documentation_down", "fallback" },

        ["<C-k>"] = { "show_signature", "hide_signature", "fallback" },
      },
    },
    signature = { enabled = true },
    appearance = {
      use_nvim_cmp_as_default = true,
      nerd_font_variant = "mono",
      kind_icons = {
        ellipsis = false,
        text = function(ctx)
          return require("lspkind").symbolic(ctx.kind, {
            mode = "symbol",
          })
        end,
      },
    },
    sources = {
      default = {
        "lazydev",
        "lsp",
        "dictionary",
        "emoji",
        "path",
        "snippets",
        "buffer",
      },
      providers = {
        minuet = {
          name = "minuet",
          module = "minuet.blink",
          score_offset = 8,
          async = true,
          timeout_ms = 10000,
          enabled = function()
            return true
          end,
        },
        lazydev = {
          name = "LazyDev",
          module = "lazydev.integrations.blink",
          score_offset = 100,
        },
        emoji = {
          module = "blink-emoji",
          name = "Emoji",
          opts = { insert = true }, -- Insert emoji (default) or complete its name
        },
        dictionary = {
          module = "blink-cmp-dictionary",
          name = "Dict",
          -- Make sure this is at least 2.
          -- 3 is recommended
          min_keyword_length = 3,
          opts = {
            -- options for blink-cmp-dictionary
          },
        },
      },
    },
    completion = {
      accept = { auto_brackets = { enabled = true } },
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 500,
        window = {
          winblend = 30,
        },
      },
      trigger = {
        prefetch_on_insert = true,
        show_on_keyword = true,
      },
      list = {
        selection = {
          auto_insert = false,
          preselect = function(ctx)
            return ctx.mode ~= "cmdline"
              and not require("blink.cmp").snippet_active({ direction = 1 })
          end,
        },
      },

      menu = {
        auto_show = true,
        border = "none",
        draw = {
          columns = {
            { "kind_icon" },
            { "label", gap = 1 },
            { "source_name" },
          },
          components = {
            label = {
              text = function(ctx)
                return require("colorful-menu").blink_components_text(ctx)
              end,
              highlight = function(ctx)
                return require("colorful-menu").blink_components_highlight(ctx)
              end,
            },
          },
        },
      },
    },
  })
  return opts
end
