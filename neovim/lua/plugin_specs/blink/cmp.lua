---@module "blink.cmp"
---@module "lazy"

local api = vim.api

local function is_text()
  return vim.list_contains(TEXT, vim.bo.filetype)
end

local lspkind

---@return LazySpec[]
return {
  {
    "saghen/blink.cmp",
    dependencies = {
      {
        "saghen/blink.compat",
        version = "*",
      },
      "rafamadriz/friendly-snippets",
      "moyiz/blink-emoji.nvim",
      "milanglacier/minuet-ai.nvim",
      "marcoSven/blink-cmp-yanky",
      "folke/lazydev.nvim",
      "archie-judd/blink-cmp-words",
      "MahanRahmati/blink-nerdfont.nvim",
    },
    build = "cargo build --release",
    event = { "InsertEnter", "CmdlineEnter" },
    version = "*",
    opts = function(_, opts)
      for _, m in ipairs({ "s", "x", "v", "o", "l" }) do
        pcall(vim.keymap.del, m, "<tab>", {})
      end
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

          ["<Esc>"] = {
            function(cmp)
              if cmp.snippet_active() then
                return vim.snippet.stop()
              end
            end,
            "fallback",
          },
          ["<Tab>"] = {
            function(cmp)
              local col = vim.fn.col(".") - 1
              if cmp.is_menu_visible() then
                return cmp.select_next()
              elseif col == 0 or vim.fn.getline("."):sub(col, col):match("%s") then
                return nil
              else
                return cmp.show()
              end
            end,
            "fallback",
          },
          ["<S-Tab>"] = { "select_prev", "fallback" },
          ["<Left>"] = { "fallback" },
          ["<Right>"] = { "fallback" },
          ["<CR>"] = {
            "accept",
            "fallback",
          },

          ["<Up>"] = { "snippet_backward", "select_prev", "fallback" },
          ["<Down>"] = { "snippet_forward", "select_next", "fallback" },
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
        signature = {
          enabled = true,
          trigger = { enabled = true, show_on_insert = true, show_on_keyword = true },
        },
        appearance = {
          use_nvim_cmp_as_default = true,
          nerd_font_variant = "mono",
          kind_icons = {
            ellipsis = false,
            text = function(ctx)
              if lspkind == nil then
                lspkind = require("lspkind").symbolic
              end
              return lspkind(ctx.kind, {
                mode = "symbol",
              })
            end,
          },
        },
        ---@type blink.cmp.SourceConfigPartial
        sources = {
          default = function()
            local sources = {
              lsp = true,
              emoji = true,
              path = true,
              snippets = true,
              buffer = true,
              nerdfont = true,
              yank = true,
              dictionary = true,
              thesaurus = true,
            }
            if package.loaded["lazydev"] then
              sources.lazydev = true
            end

            if api.nvim_buf_get_name(0):find("lsp:rename$") then
              return { "buffer" }
            end

            return vim
              .iter(sources)
              :map(function(k, v)
                if v then
                  return k
                end
              end)
              :totable()
          end,
          providers = {
            lsp = { async = true, score_offset = 1 },
            snippets = { score_offset = 1, max_items = 3 },
            path = {
              module = "blink.cmp.sources.path",
              score_offset = 10,
            },
            nerdfont = {
              module = "blink-nerdfont",
              name = "Nerd Fonts",
              -- score_offset = 15, -- Tune by preference
              opts = { insert = true }, -- Insert nerdfont icon (default) or complete its name
            },
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
              enabled = function()
                return package.loaded["lazydev"] ~= nil
              end,
            },
            emoji = {
              module = "blink-emoji",
              name = "Emoji",
              opts = { insert = true }, -- Insert emoji (default) or complete its name
              max_items = 5,
            },
            thesaurus = {
              name = "Synm",
              module = "blink-cmp-words.thesaurus",
              opts = {
                definition_pointers = { "!", "&", "^" },
                similarity_pointers = { "&", "^" },
                similarity_depth = 2,
              },
              max_items = 3,
              enabled = is_text,
              score_offset = 0,
            },
            dictionary = {
              name = "Dict",
              score_offset = 0,
              module = "blink-cmp-words.dictionary",
              opts = {
                dictionary_search_threshold = 3,
                definition_pointers = { "!", "&", "^" },
              },
              max_items = function()
                if is_text() then
                  return 3
                else
                  return 1
                end
              end,
              enabled = is_text,
            },
            yank = {
              name = "Yank",
              module = "blink-yanky",
              opts = {
                minLength = 3,
                onlyCurrentFiletype = false,
                -- trigger_characters = { '"' },
                kind_icon = "󰅍",
              },
              max_items = 3,
              score_offset = 0,
            },
          },
        },
        completion = {
          accept = { auto_brackets = { enabled = true } },
          documentation = {
            auto_show = true,
            auto_show_delay_ms = 500,
            window = {
              winblend = 0,
            },
          },
          trigger = {
            prefetch_on_insert = true,
            show_on_keyword = true,
            show_on_trigger_character = true,
            show_in_snippet = true,
            show_on_insert_on_trigger_character = true,
            show_on_accept_on_trigger_character = true,
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
          keyword = { range = "full" },
        },
        fuzzy = {
          implementation = "prefer_rust_with_warning",
          sorts = {
            "exact",
            "score",
            "sort_text",
          },
        },
      })
      return opts
    end,
    cond = require("_utils").no_vscode,
  },
  {
    "garymjr/nvim-snippets",
    -- custom snippets by filetypes at ~/.config/nvim/snippets/
    event = { "InsertEnter" },
    opts = {
      friendly_snippets = true,
      create_autocmd = true,
      create_cmp_source = false,
    },
    dependencies = { "rafamadriz/friendly-snippets" },
    cond = require("_utils").no_vscode,
  },
  {
    "gbprod/yanky.nvim",
    opts = {
      ring = { history_length = 5 },
      system_clipboard = {
        sync_with_ring = true,
        clipboard_register = nil,
      },
    },
  },
}
