---@module "lazy"

local keymap_utils = require("keymaps.utils")

---@type LazySpec[]
return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      pcall(function()
        require("nvim-dap-repl-highlights").setup()
      end)
      require("nvim-treesitter").setup()

      require("nvim-treesitter").install({ "dap_repl" })

      -- vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
    end,
    build = ":TSUpdate",
    cond = require("_utils").no_vscode,
    dependencies = {
      "williamboman/mason.nvim",
      {
        "MeanderingProgrammer/treesitter-modules.nvim",
        dependencies = {
          "nvim-treesitter/nvim-treesitter",
          { "LiadOz/nvim-dap-repl-highlights" },
        },
        ---@module 'treesitter-modules'
        ---@return ts.mod.UserConfig
        opts = function(_, opts)
          ---@type ts.mod.UserConfig
          opts = vim.tbl_deep_extend("force", {
            ignore_install = { "csv" },
            auto_install = true,
            highlight = {
              enable = true,
              additional_vim_regex_highlighting = false,
            },
            indent = { enable = true },
            incremental_selection = {
              enable = true,
              keymaps = {
                init_selection = "<TAB>",
                node_incremental = "<TAB>",
                scope_incremental = false,
                node_decremental = "<S-TAB>",
              },
            },
          }, opts or {})
          if #vim.uv.cpu_info() >= 4 then
            opts.ensure_installed = require("_utils").treesitter_parsers
          end
          return opts
        end,
      },
    },
  },

  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    opts = { move = { set_jumps = true } },
    event = "FileType",
    keys = {
      {
        "]f",
        function()
          require("nvim-treesitter-textobjects.move").goto_next_start(
            "@function.outer",
            "textobjects"
          )
        end,
        desc = "Next function",
      },
      {
        "[f",
        function()
          require("nvim-treesitter-textobjects.move").goto_previous_start(
            "@function.outer",
            "textobjects"
          )
        end,
        desc = "Previous function",
      },
      {
        "vif",
        function()
          require("nvim-treesitter-textobjects.select").select_textobject(
            "@function.inner",
            "textobjects"
          )
        end,
        desc = "Select inner function.",
      },

      {
        "]c",
        function()
          require("nvim-treesitter-textobjects.move").goto_next_start(
            "@class.outer",
            "textobjects"
          )
        end,
        desc = "Next class",
      },
      {
        "[c",
        function()
          require("nvim-treesitter-textobjects.move").goto_previous_start(
            "@class.outer",
            "textobjects"
          )
        end,
        desc = "Previous class",
      },

      {
        "<leader>>",
        function()
          require("nvim-treesitter-textobjects.swap").swap_next("@parameter.inner")
        end,
        desc = "Swap with next parameter",
      },
      {
        "<leader><",
        function()
          require("nvim-treesitter-textobjects.swap").swap_previous("@parameter.inner")
        end,
        desc = "Swap with previous parameter",
      },
    },
  },
  -- {
  --   "andymass/vim-matchup",
  --   event = "FileType",
  --   init = function()
  --     vim.g.matchup_matchparen_offscreen = {
  --       -- method = "popup",
  --       method = "status_manual",
  --       fullwidth = 0,
  --       border = "none",
  --       highlight = "FidgetNormal",
  --     }
  --     api.nvim_create_autocmd({ "BufNewFile", "BufReadPost" }, {
  --       callback = function()
  --         api.nvim_set_hl(0, "MatchWord", { bold = true, italic = true })
  --         api.nvim_set_hl(0, "MatchupVirtualText", {
  --           bold = true,
  --           italic = true,
  --           fg = api.nvim_get_hl(0, { name = "Comment" }).fg,
  --         })
  --       end,
  --     })
  --   end,
  -- },
  {
    "ThePrimeagen/refactoring.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    cond = require("_utils").no_vscode,
    config = function()
      require("refactoring").setup({
        show_success_message = true,
        prompt_func_return_type = {
          go = false,
          java = false,
          cpp = false,
          c = false,
          h = false,
          hpp = false,
          cxx = false,
        },
        prompt_func_param_type = {
          go = false,
          java = false,
          cpp = false,
          c = false,
          h = false,
          hpp = false,
          cxx = false,
        },
        printf_statements = {},
        print_var_statements = {},
      })
    end,
    keys = {
      {
        "<leader>ef",
        keymap_utils.make_keymap_callback({
          function()
            return require("refactoring").refactor("Extract Function")
          end,
          rust = function()
            vim.lsp.buf.code_action({
              apply = true,
              filter = function(x)
                return x.kind == "refactor.extract"
                  and x.title:lower():find("function") ~= nil
              end,
            })
          end,
        }),
        desc = "Extract Function",
        noremap = true,
        expr = true,
        mode = { "x" },
      },
      {
        "<leader>ev",
        keymap_utils.make_keymap_callback({
          function()
            return require("refactoring").refactor("Extract Variable")
          end,
          rust = function()
            vim.lsp.buf.code_action({
              apply = true,
              filter = function(x)
                return x.kind == "refactor.extract"
                  and (string.find(x.title:lower(), "variable") ~= nil)
              end,
            })
          end,
        }),
        desc = "Extract Variable",
        noremap = true,
        expr = true,
        mode = { "x" },
      },
      {
        "<leader>iF",
        keymap_utils.make_keymap_callback({
          function()
            return require("refactoring").refactor("Inline Function")
          end,
          rust = function()
            vim.lsp.buf.code_action({
              apply = true,
              filter = function(x)
                return x.kind == "refactor.inline"
                  and vim.iter({ "function", "callers" }):any(function(kw)
                    return string.find(x.title:lower(), kw) ~= nil
                  end)
              end,
            })
          end,
        }),
        desc = "Inline Function",
        noremap = true,
        expr = true,
        mode = { "x", "n" },
      },
      {
        "<leader>iv",
        keymap_utils.make_keymap_callback({
          function()
            return require("refactoring").refactor("Inline Variable")
          end,
          rust = function()
            vim.lsp.buf.code_action({
              apply = true,
              filter = function(x)
                return x.kind == "refactor.inline"
                  and (string.find(x.title:lower(), "variable") ~= nil)
              end,
            })
          end,
        }),
        desc = "Inline Variable",
        noremap = true,
        expr = true,
        mode = { "x", "n" },
      },
      {
        "<leader>eb",
        function()
          return require("refactoring").refactor("Extract Block")
        end,
        desc = "Extract block",
        noremap = true,
        expr = true,
        mode = { "n" },
      },
      {
        "<leader>ebf",
        function()
          return require("refactoring").refactor("Extract Block To File")
        end,
        desc = "Extract block to file",
        noremap = true,
        expr = true,
        mode = { "n" },
      },
      {
        "<leader>rp",
        function()
          return require("refactoring").debug.print_var({})
        end,
        mode = { "n" },
        expr = true,
        desc = "Add debug print statement.",
      },
      {
        "<leader>rc",
        function()
          return require("refactoring").debug.cleanup({})
        end,
        mode = { "n" },
        expr = true,
        desc = "Clear debug print statement.",
      },
      {
        "<leader>rr",
        function()
          require("refactoring").select_refactor({ prefer_ex_cmd = true })
        end,
        mode = { "n", "x" },
        desc = "Select refactoring.",
      },
    },
  },
  {
    "mtrajano/tssorter.nvim",
    version = "*",
    opts = {},
    keys = {
      {
        "<leader>s",
        function()
          require("tssorter").sort({})
        end,
        mode = { "n", "x" },
        desc = "sort selected treesitter nodes.",
      },
      {
        "<leader>S",
        function()
          require("tssorter").sort({ reverse = true })
        end,
        mode = { "n", "x" },
        desc = "sort selected treesitter nodes (reversed).",
      },
    },
  },
  {
    "kylechui/nvim-surround",
    opts = {},
    event = "FileType",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
  },
  {
    "shellRaining/hlchunk.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = function()
      local palette = require("catppuccin.palettes.mocha")
      local excluded_ft = {
        ["neo-tree"] = true,
        snacks_dashboard = true,
        fidget = true,
        help = true,
        snacks_picker_preview = true,
      }

      local indent_colors = {
        palette.surface0,
        palette.surface1,
        palette.surface2,
        palette.overlay0,
        palette.overlay1,
        palette.overlay2,
        palette.subtext0,
        palette.subtext1,
        palette.text,
      }
      return {
        chunk = {
          delay = 100,
          enable = true,
          exclude_filetypes = excluded_ft,
          style = palette.lavender,
        },
        indent = {
          enable = true,
          exclude_filetypes = excluded_ft,
          style = indent_colors,
        },
      }
    end,
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    cond = require("_utils").no_vscode,
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    opts = function()
      vim.treesitter.language.register("markdown", "vimwiki")
      return {
        file_types = { "markdown", "vimwiki", "codecompanion" },
        completions = {
          lsp = { enabled = true },
        },
      }
    end,
    ft = { "markdown", "vimwiki", "codecompanion" },
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-mini/mini.icons" },
  },

  {
    "Sam-programs/cmdline-hl.nvim",
    event = { "CmdlineChanged", "CmdlineEnter" },
    opts = {
      inline_ghost_text = false,
      type_signs = { [":"] = { " ", "Title" }, ["/"] = { " ", "Title" } },
    },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    opts = function(self, opts)
      ---@module "treesitter-context"
      ---@type TSContext.UserConfig
      return vim.tbl_deep_extend("force", opts or {}, {
        enable = true,
        min_window_height = 40,
        max_lines = 10,
        trim_scope = "outer",
        -- ---@param bufnr integer
        -- on_attach = function(bufnr)
        --   return vim.fn.winheight(vim.fn.bufwinid(bufnr)) >= 40
        -- end,
      })
    end,
    cmd = { "TSContext" },
    event = "FileType",
  },
}
