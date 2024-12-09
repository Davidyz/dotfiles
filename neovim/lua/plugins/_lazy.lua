M = {}
local utils = require("_utils")

local icon_provider = "echasnovski/mini.icons"
local cmp_engine = "hrsh7th/nvim-cmp"
-- local cmp_engine = "iguanacucumber/magazine.nvim"
M.plugins = {
  -- NOTE: icons
  {
    "echasnovski/mini.icons",
    opts = {},
    lazy = true,
    specs = {
      { "nvim-tree/nvim-web-devicons", enabled = false, optional = true },
    },
    init = function()
      package.preload["nvim-web-devicons"] = function()
        require("mini.icons").mock_nvim_web_devicons()
        return package.loaded["nvim-web-devicons"]
      end
    end,
    cond = function()
      return icon_provider == "echasnovski/mini.icons"
    end,
  },
  {
    "nvim-tree/nvim-web-devicons",
    cond = function()
      return icon_provider == "nvim-tree/nvim-web-devicons"
    end,
    dependencies = {},
  },

  -- NOTE: filetypes
  {
    "stevearc/vim-arduino",
    ft = { "arduino" },
    cond = function()
      return vim.fn.executable("arduino-cli") ~= 0 and utils.no_vscode()
    end,
  },
  {
    "lervag/vimtex",
    ft = { "tex" },
    cond = utils.no_vscode,
    config = function()
      require("executable-checker").add_executable(
        { "zathura", "xdotool", "biber" },
        "vimtex"
      )
      vim.g.vimtex_quickfix_mode = 0
      vim.g.vimtex_syntax_enabled = 0

      if vim.fn.executable("zathura") then
        vim.g.vimtex_view_method = "zathura"
      else
        vim.g.vimtex_view_method = "general"
        vim.g.vimtex_view_general_viewer = "firefox"
      end
      vim.api.nvim_create_autocmd(
        { "BufEnter", "BufWritePost" },
        { command = "VimtexView", pattern = "*.tex" }
      )
      --vim.g.vimtex_view_general_viewer = "okular"
      --vim.g.vimtex_view_general_options = "--unique file:@pdf#src:@line@tex"
    end,
  },
  {
    "shiracamus/vim-syntax-x86-objdump-d",
    cond = function()
      return vim.fn.executable("objdump") ~= 0
    end,
  },
  {
    "neovimhaskell/haskell-vim",
    ft = { "haskell", "hs" },
    init = function()
      vim.g.haskell_enable_quantification = 1
      vim.g.haskell_enable_recursivedo = 1
      vim.g.haskell_enable_arrowsyntax = 1
      vim.g.haskell_enable_pattern_synonyms = 1
      vim.g.haskell_enable_typeroles = 1
      vim.g.haskell_enable_static_pointers = 1
      vim.g.haskell_backpack = 1
      vim.g.haskell_indent_if = 3
      vim.g.haskell_indent_case = 2
      vim.g.haskell_indent_let = 4
      vim.g.haskell_indent_where = 6
      vim.g.haskell_indent_before_where = 2
      vim.g.haskell_indent_after_bare_where = 2
      vim.g.haskell_indent_do = 3
      vim.g.haskell_indent_in = 1
      vim.g.haskell_indent_guard = 2
      vim.g.haskell_indent_case_alternative = 1
      vim.g.cabal_indent_section = 2
    end,
  },
  {
    "cameron-wags/rainbow_csv.nvim",
    config = true,
    ft = {
      "csv",
      "tsv",
      "csv_semicolon",
      "csv_whitespace",
      "csv_pipe",
      "rfc_csv",
      "rfc_semicolon",
    },
    cmd = {
      "RainbowDelim",
      "RainbowDelimSimple",
      "RainbowDelimQuoted",
      "RainbowMultiDelim",
    },
  },
  {
    "lark-parser/vim-lark-syntax",
    ft = { "lark" },
  },
  {
    "vim-scripts/cup.vim",
    ft = { "cup" },
  },
  {
    "udalov/javap-vim",
    ft = { "javap" },
  },
  {
    "cespare/vim-toml",
    branch = "main",
    ft = { "toml" },
  },
  {
    "vim-scripts/crontab.vim",
    ft = { "crontab" },
  },

  -- NOTE: markdown
  {
    "hedyhli/markdown-toc.nvim",
    ft = { "markdown" },
    opts = { headings = { before_toc = false } },
  },
  {
    "Myzel394/easytables.nvim",
    cmd = { "EasyTablesCreateNew", "EasyTablesImportThisTable" },
    opts = {},
  },
  {
    "toppair/peek.nvim",
    ft = { "markdown" },
    build = "deno task --quiet build:fast",
    opts = { theme = "dark", filetype = { "markdown", "pandoc" }, app = "firefox" },
    main = "peek",
    keys = {
      {
        "mp",
        function()
          local peek = require("peek")
          if peek.is_open() then
            peek.close()
          else
            peek.open()
          end
        end,
      },
      mode = "n",
    },
    cond = function()
      return utils.no_vscode() and vim.fn.executable("deno") ~= 0
    end,
  },

  -- color schemes.
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function(_, opts)
      require("catppuccin").setup(opts)
      vim.cmd.colorscheme("catppuccin")
      vim.api.nvim_set_hl(0, "CursorColumn", { link = "CursorLine" })
    end,
    lazy = false,
    opts = function()
      local flavour = "mocha"
      return {
        flavour = flavour,
        term_colors = true,
        custom_highlights = function(colors)
          return {
            TelescopeNormal = {
              bg = colors.mantle,
              fg = colors.text,
            },
            TelescopeBorder = {
              bg = colors.mantle,
              fg = colors.mantle,
            },
            TelescopePromptNormal = {
              bg = colors.crust,
              fg = colors.lavender,
            },
            TelescopePromptBorder = {
              bg = colors.crust,
              fg = colors.crust,
            },
            TelescopePromptTitle = {
              bg = colors.crust,
              fg = colors.crust,
            },
            TelescopePreviewTitle = {
              bg = colors.mantle,
              fg = colors.mantle,
            },
            TelescopeResultsTitle = {
              bg = colors.mantle,
              fg = colors.mantle,
            },
            FloatBorder = { fg = colors.mantle, bg = colors.mantle },
            FloatTitle = { fg = colors.lavender, bg = colors.mantle },
            LspInfoBorder = { fg = colors.mantle, bg = colors.mantle },
            WinSeparator = { bg = colors.base, fg = colors.lavender },
          }
        end,
        dim_inactive = { enabled = false },
        default_integrations = {
          diffview = true,
          fidget = true,
          headlines = true,
          hop = true,
          lspsaga = true,
          mason = true,
          mini = { enabled = true },
          native_lsp = { enabled = true },
          navic = { enabled = true },
          neotree = true,
          nvim_surround = true,
          rainbow_delimiters = true,
          snacks = true,
          which_key = true,
        },
      }
    end,
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    opts = function()
      vim.treesitter.language.register("markdown", "vimwiki")
      return { file_types = { "markdown", "vimwiki" } }
    end,
    ft = { "markdown", "vimwiki" },
    dependencies = { "nvim-treesitter/nvim-treesitter", icon_provider },
  },

  -- NOTE: tree sitter
  {
    "nvim-treesitter/nvim-treesitter",
    config = function()
      require("plugins.tree_sitter")
    end,
    build = ":TSUpdate",
    cond = utils.no_vscode,
    dependencies = { "williamboman/mason.nvim" },
  },
  {
    "hiphish/rainbow-delimiters.nvim",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      local rainbow_delimiters = require("rainbow-delimiters")
      vim.g.rainbow_delimiters = {
        strategy = {
          [""] = rainbow_delimiters.strategy["global"],
          vim = rainbow_delimiters.strategy["local"],
        },
        query = {
          [""] = "rainbow-delimiters",
          lua = "rainbow-blocks",
        },
        highlight = {
          "RainbowDelimiterRed",
          "RainbowDelimiterYellow",
          "RainbowDelimiterBlue",
          "RainbowDelimiterOrange",
          "RainbowDelimiterGreen",
          "RainbowDelimiterViolet",
          "RainbowDelimiterCyan",
        },
      }
      vim.api.nvim_set_hl(
        0,
        "MatchParen",
        ---@diagnostic disable-next-line: param-type-mismatch
        vim.tbl_deep_extend(
          "force",
          vim.api.nvim_get_hl(0, { name = "MatchParen" }),
          { fg = "NONE" }
        )
      )
    end,
    dependencies = { "nvim-treesitter/nvim-treesitter" },
  },
  {
    "nvim-treesitter/playground",
    cmd = "TSPlaygroundToggle",
    cond = utils.no_vscode,
  },
  {
    "windwp/nvim-autopairs",
    cond = utils.no_vscode,
    config = function()
      require("plugins.nvim_autopairs")
    end,
    event = "LspAttach",
  },
  {
    "andymass/vim-matchup",
    event = { "BufReadPost", "BufNewFile" },
    init = function()
      vim.g.matchup_matchparen_offscreen =
        { method = "popup", fullwidth = 1, highlight = "Comment" }
      vim.api.nvim_create_autocmd({ "BufNewFile", "BufReadPost" }, {
        callback = function()
          vim.api.nvim_set_hl(0, "MatchWord", { bold = true, italic = true })
          vim.api.nvim_set_hl(0, "MatchupVirtualText", {
            bold = true,
            italic = true,
            fg = vim.api.nvim_get_hl(0, { name = "Comment" }).fg,
          })
        end,
      })
    end,
  },
  {
    "kevinhwang91/nvim-ufo",
    dependencies = {
      "kevinhwang91/promise-async",
      "nvim-treesitter/nvim-treesitter",
      "neovim/nvim-lspconfig",
    },
    cond = utils.no_vscode,
    init = function()
      vim.o.foldenable = true
      vim.o.foldlevel = 99
      vim.o.foldlevelstart = 99
      vim.o.foldcolumn = "0"
    end,
    config = function(_, opts)
      require("ufo").setup(opts)
      vim.api.nvim_set_hl(0, "UfoCursorFoldedLine", { link = "CursorLine" })
      vim.api.nvim_set_hl(0, "UfoPreviewBg", { link = "TelescopePreviewBorder" })
      vim.api.nvim_set_hl(0, "UfoPreviewWinBar", { link = "TelescopePreviewBorder" })
      vim.api.nvim_set_hl(0, "UfoFoldedBg", { link = "CursorLine" })
      vim.keymap.set("n", "<C-p>", function()
        require("ufo.preview"):peekFoldedLinesUnderCursor()
      end, { noremap = true, desc = "Peek inside fold." })
      vim.keymap.set("n", "<BS>", "za", { noremap = true, desc = "Toggle fold." })
    end,
    opts = {
      preview = {
        win_config = { winhighlight = "Normal:TelescopePreviewBorder", winblend = 0 },
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
        table.insert(result, { "  ", "NonText" })
        table.insert(result, { suffix, "TSPunctBracket" })
        return result
      end,
      provider_selector = function(bufnum, _, _)
        if vim.bo.bt == "nofile" then
          return ""
        end
        local servers = vim.lsp.get_clients({ bufnr = bufnum })
        if
          #servers > 0
          and utils.any(servers, function(server)
            return server.server_capabilities.foldingRangeProvider == true
          end)
        then
          return { "lsp", "treesitter" }
        end
        return { "treesitter", "indent" }
      end,
    },
    event = { "LspAttach" },
  },
  {
    "rachartier/tiny-inline-diagnostic.nvim",
    event = { "LspAttach" },
    dependencies = { "neovim/nvim-lspconfig", "nvimtools/none-ls.nvim" },
    init = function()
      vim.diagnostic.config({
        virtual_text = false,
      })
    end,
    main = "tiny-inline-diagnostic",
    cond = utils.no_vscode,
    opts = {
      options = {
        multiple_diag_under_cursor = true,
        show_source = true,
      },
    },
  },

  -- NOTE: mason
  {
    "williamboman/mason.nvim",
    init = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "mason",
        callback = function()
          vim.o.cursorline = false
        end,
      })
      require("executable-checker").add_executable({ "python3", "npm" }, "mason")
    end,
    opts = {
      ui = { height = 0.8 },
      max_concurrent_jobs = math.min(4, utils.cpu_count()),
      PATH = "append",
    },
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    event = { "BufReadPost", "BufNewFile" },
    cmd = { "MasonToolsInstall", "MasonToolsUpdate", "MasonToolsClean" },
    config = function()
      require("plugins.mason_tools")
    end,
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      {
        "jay-babu/mason-null-ls.nvim",
        dependencies = {
          "williamboman/mason.nvim",
          "nvimtools/none-ls.nvim",
        },
        opts = {
          ensure_installed = nil,
          automatic_installation = true,
        },
        config = true,
      },
    },
  },
  {
    "nvimtools/none-ls.nvim",
    event = { "BufReadPost", "BufNewFile" },
    config = require("plugins.null_ls"),
    dependencies = { "williamboman/mason.nvim" },
  },

  -- NOTE: lsp
  {
    "neovim/nvim-lspconfig",
    version = "*",
    config = function()
      require("plugins._lsp")
      require("keymaps._lsp")
      require("lspconfig.ui.windows").default_options.border = { " " }
    end,
    event = { "BufReadPost", "BufNewFile", "CmdlineEnter" },
    cond = utils.no_vscode,
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
  },
  {
    "williamboman/mason-lspconfig.nvim",
    cond = utils.no_vscode,
  },
  {
    cmp_engine,
    name = "nvim-cmp",
    cond = utils.no_vscode,
    opts = function()
      return require("keymaps.cmp")
    end,
    dependencies = {
      "brenoprata10/nvim-highlight-colors",
      "lukas-reineke/cmp-under-comparator",
      "onsails/lspkind.nvim",
      "hrsh7th/cmp-buffer",
      "tzachar/cmp-ai",
    },
    event = { "InsertEnter", "CmdlineEnter" },
  },
  {
    "tzachar/cmp-ai",
    dependencies = "nvim-lua/plenary.nvim",
    cond = function()
      return utils.no_vscode()
        and (vim.fn.executable("ollama") or os.getenv("OLLAMA_HOST"))
    end,
    config = function()
      local cmp_ai = require("cmp_ai.config")
      cmp_ai:setup({
        max_lines = 1000,
        provider = "Ollama",
        provider_options = {
          base_url = os.getenv("OLLAMA_HOST") .. "/api/generate",
          model = "qwen2.5-coder:7b-base-q6_K",
          options = {
            temperature = 0.2,
          },
          prompt = function(lines_before, lines_after)
            local prompt = "Fill in the middle from the given context for this "
              .. vim.bo.filetype
              .. " code."
              .. "<|fim_prefix|>"
              .. lines_before
              .. "<|fim_suffix|>"
              .. lines_after
              .. "<|fim_middle|>"

            return prompt
          end,
        },
        notify = true,
        notify_callback = function(msg)
          vim.notify(msg, "info", { title = "cmp-ai" })
        end,
        run_on_every_keystroke = false,
        ignored_file_types = {
          -- default is not to ignore
          -- uncomment to ignore in lua:
          -- lua = true
        },
      })
    end,
  },
  {
    "hrsh7th/cmp-nvim-lsp",
    event = { "InsertEnter" },
    cond = utils.no_vscode,
  },
  {
    "hrsh7th/cmp-buffer",
  },
  {
    "https://codeberg.org/FelipeLema/cmp-async-path.git",
    event = { "InsertEnter", "CmdlineEnter" },
    cond = utils.no_vscode,
  },
  {
    "chrisgrieser/cmp_yanky",
    event = { "InsertEnter", "CmdlineEnter" },
    cond = utils.no_vscode,
    dependencies = {
      {
        "gbprod/yanky.nvim",
        opts = {},
      },
    },
  },
  {
    "Davidyz/codicons.nvim",
    branch = "cmp-integration",
    opts = {},
    config = true,
    event = { "InsertEnter" },
    dependencies = { cmp_engine },
    cond = utils.no_vscode,
  },
  {
    "hrsh7th/cmp-cmdline",
    event = { "InsertEnter", "CmdlineEnter" },
    cond = utils.no_vscode,
    dependencies = { cmp_engine, "hrsh7th/cmp-buffer" },
    config = function()
      local compare = require("cmp.config.compare")
      local cmp = require("cmp")
      cmp.setup.cmdline({ "/", "?", ":" }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = "async_path" },
          { name = "cmdline" },
          {
            name = "lazydev",
            group_index = 0,
          },
          { name = "nvim_lsp", keyword_length = 1, priority = 9 },
          { name = "buffer", keyword_length = 2, priority = 3 },
          { name = "cmp_yanky", option = { onlyCurrentFiletype = false } },
          { name = "nvim_lsp_signature_help" },
        }),
        sorting = {
          priority_weight = 1,
          comparators = {
            compare.exact,
            compare.kind,
            compare.score,
            compare.recently_used,
            compare.locality,
            require("cmp-under-comparator").under,
            compare.order,
            compare.offset,
            compare.sort_text,
          },
        },
      })
    end,
  },
  {
    "DasGandlaf/nvim-autohotkey",
    ft = { "autohotkey" },
    config = function()
      require("nvim-autohotkey")
      require("cmp").setup.filetype({ "autohotkey" }, {
        sources = { { name = "autohotkey" } },
      })
    end,
  },
  {
    "garymjr/nvim-snippets",
    -- custom snippets by filetypes at ~/.config/nvim/snippets/
    event = { "InsertEnter" },
    opts = { friendly_snippets = true },
    config = function(_, opts)
      require("snippets").setup(opts)
    end,
    dependencies = { "rafamadriz/friendly-snippets" },
    cond = utils.no_vscode,
  },
  {
    "hrsh7th/cmp-nvim-lsp-signature-help",
    event = { "InsertEnter" },
    cond = utils.no_vscode,
  },
  {
    "SmiteshP/nvim-navic",
    opts = {
      lsp = { auto_attach = true },
      icons = require("_utils").codicons,
    },
    event = "LspAttach",
    cond = utils.no_vscode,
    dependencies = { "neovim/nvim-lspconfig" },
  },
  {
    "tamago324/cmp-zsh",
    build = function()
      if vim.fn.executable("zsh") then
        io.popen('zsh -c "zmodload zsh/zpty"')
      end
    end,
    main = "cmp_zsh",
    opts = { zshrc = true, filetypes = { "zsh" } },
    cond = function()
      return utils.no_vscode() and vim.fn.executable("zsh") ~= 0
    end,
    ft = { "zsh" },
  },
  { "hrsh7th/cmp-emoji", event = { "InsertEnter" } },
  { "kdheepak/cmp-latex-symbols", event = { "InsertEnter" } },
  {
    "j-hui/fidget.nvim",
    event = "LspAttach",
    version = "*",
    opts = {
      notification = {
        window = {
          winblend = 0,
          align = "bottom",
          x_padding = 0,
          border = { "" },
        },
        view = { stack_upwards = false },
      },
    },
    cond = utils.no_vscode,
  },
  {
    "aznhe21/actions-preview.nvim",
    keys = {
      {
        "<Leader>a",
        [[<cmd>lua require("actions-preview").code_actions()<cr>]],
        mode = { "v", "n" },
        desc = "Code Actions",
      },
    },
    dependencies = { "nvim-telescope/telescope.nvim" },
    opts = function()
      return {
        telescope = {
          sorting_strategy = "ascending",
          layout_strategy = "vertical",
          layout_config = {
            width = 0.8,
            height = 0.9,
            prompt_position = "top",
            preview_cutoff = 20,
            preview_height = function(_, _, max_lines)
              return max_lines - 15
            end,
          },
        },
      }
    end,
    cond = utils.no_vscode,
  },
  {
    "smjonas/inc-rename.nvim",
    opts = {
      input_buffer_type = "dressing",
    },
    dependencies = { "stevearc/dressing.nvim" },
    cmd = { "IncRename" },
    keys = {
      {
        "<Leader>rv",
        function()
          return ":IncRename " .. vim.fn.expand("<cword>")
        end,
        mode = "n",
        expr = true,
        desc = "LSP rename.",
      },
    },
  },
  {
    "ThePrimeagen/refactoring.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "nvim-telescope/telescope.nvim",
    },
    cond = utils.no_vscode,
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
      require("telescope").load_extension("refactoring")
    end,
    keys = {
      {
        "<leader>ef",
        function()
          require("refactoring").refactor("Extract Function")
        end,
        desc = "Extract Function",
        noremap = true,
        mode = { "x" },
      },
      {
        "<leader>ev",
        function()
          require("refactoring").refactor("Extract Variable")
        end,
        desc = "Extract Variable",
        noremap = true,
        mode = { "x" },
      },
      {
        "<leader>if",
        function()
          require("refactoring").refactor("Inline Function")
        end,
        desc = "Inline Function",
        noremap = true,
        mode = { "x" },
      },
      {
        "<leader>iv",
        function()
          require("refactoring").refactor("Inline Variable")
        end,
        desc = "Inline Variable",
        noremap = true,
        mode = { "x" },
      },
      {
        "<leader>eb",
        function()
          require("refactoring").refactor("Extract Block")
        end,
        desc = "Extract block",
        noremap = true,
        mode = { "n" },
      },
      {
        "<leader>ebf",
        function()
          require("refactoring").refactor("Extract Block To File")
        end,
        desc = "Extract block to file",
        noremap = true,
        mode = { "n" },
      },
      {
        "<leader>rp",
        function()
          require("refactoring").debug.print_var({})
        end,
        mode = { "n" },
        desc = "Add debug print statement.",
      },
      {
        "<leader>rc",
        function()
          require("refactoring").debug.cleanup({})
        end,
        mode = { "n" },
        desc = "Clear debug print statement.",
      },
      {
        "<leader>rr",
        function()
          require("telescope").extensions.refactoring.refactors({
            theme = "cursor",
            layout_config = { width = 0.4, height = 0.4 },
            layout_strategy = "cursor",
          })
        end,
        mode = { "n", "x" },
        desc = "Select refactoring.",
      },
    },
  },
  {
    "hedyhli/outline.nvim",
    cond = utils.no_vscode,
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
      vim.api.nvim_create_autocmd("BufEnter", {
        nested = true,
        callback = function()
          if #vim.api.nvim_list_wins() == 1 and vim.bo.filetype == "Outline" then
            vim.cmd("quit")
          end
        end,
      })
    end,
  },
  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        { path = "luvit-meta/library", words = { "vim%.uv" } },
        { path = "wezterm-types", mods = { "wezterm" } },
      },
    },
    dependencies = {
      { "Bilal2453/luvit-meta" },
      { "justinsgithub/wezterm-types" },
    },
  },
  {
    "barreiroleo/ltex_extra.nvim",
    ft = { "markdown", "tex" },
    dependencies = { "neovim/nvim-lspconfig" },
    config = false,
    cond = function()
      if vim.fn.executable("java") then
        local output = vim.fn.execute("!java -version") or ""
        local java_ver_num = string.match(output, "build (%d+)") or 0
        return tonumber(java_ver_num) > 11
      end
      return false
    end,
  },
  {
    "linux-cultist/venv-selector.nvim",
    branch = "regexp",
    dependencies = { "neovim/nvim-lspconfig" },
    cmd = { "VenvSelect", "VenvSelectCurrent" },
    opts = { auto_refresh = true, name = { "venv", ".venv" } },
  },
  {
    "Davidyz/inlayhint-filler.nvim",
    keys = {
      {
        "<Leader>I",
        function()
          require("inlayhint-filler").fill({})
        end,
      },
    },
  },

  -- NOTE: dap
  {
    "mfussenegger/nvim-dap",
    cond = utils.no_vscode,
    config = function()
      require("plugins.dap")
      -- require("keymaps.dap")
    end,
    keys = {
      {
        "<leader>d",
        function()
          require("dapui").toggle()
        end,
        desc = "Toggle DAP UI.",
      },
      { "<F5>", "<cmd>DapContinue<CR>", desc = "DAP Continue." },
      { "<Space>o", "<cmd>DapStepOver<CR>", desc = "DAP Step [O]ver.", noremap = true },
      { "<Space>i", "<cmd>DapStepOver<CR>", desc = "DAP Step [I]nto.", noremap = true },
      { "<Space>q", "<cmd>DapStepOut<CR>", desc = "DAP Step Out.", noremap = true },
      {
        "<Space>b",
        "<cmd>DapToggleBreakpoint<CR>",
        desc = "DAP Toggle [B]reakpoint.",
        noremap = true,
      },
    },
    cmd = {
      "DapShowLog",
      "DapContinue",
      "DapToggleBreakpoint",
      "DapToggleRepl",
      "DapStepOver",
      "DapStepInto",
      "DapStepOut",
      "DapTerminate",
      "DapLoadLaunchJSON",
      "DapRestartFrame",
      "DapInstall",
      "DapUninstall",
    },
    dependencies = {
      {
        "theHamsta/nvim-dap-virtual-text",
        cond = utils.no_vscode,
      },
      {
        "rcarriga/nvim-dap-ui",
        cond = utils.no_vscode,
        dependencies = { "nvim-neotest/nvim-nio" },
      },
      {
        "jbyuki/one-small-step-for-vimkind",
        cond = utils.no_vscode,
      },
      {
        "jay-babu/mason-nvim-dap.nvim",
        cond = utils.no_vscode,
      },
    },
  },

  -- NOTE: misc
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    version = "*",
    opts = function()
      return {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
        bigfile = { enabled = true },
        notifier = { enabled = true },
        quickfile = { enabled = true },
        statuscolumn = {
          enabled = true,
          left = { "mark", "sign", "git" },
          right = { "fold" },
        },
        dashboard = {
          enabled = true,
          wo = { statusline = nil },
          sections = {
            { section = "header" },
            { section = "keys", gap = 0 },
            {
              icon = " ",
              title = "Recent Files",
              section = "recent_files",
              indent = 2,
              padding = { 2, 2 },
            },
            {
              icon = " ",
              title = "Projects",
              section = "projects",
              indent = 2,
              enabled = require("snacks").git.get_root() == nil,
              padding = 2,
            },
            {
              pane = 2,
              icon = " ",
              title = "Git Status",
              section = "terminal",
              enabled = require("snacks").git.get_root() ~= nil,
              cmd = "git status --short --branch --renames",
              height = 5,
              padding = 1,
              ttl = 5 * 60,
              indent = 3,
            },
            { section = "startup" },
          },
          preset = {
            keys = {
              {
                icon = " ",
                key = "f",
                desc = "Find File",
                action = ":lua Snacks.dashboard.pick('files')",
              },
              {
                icon = " ",
                key = "n",
                desc = "New File",
                action = ":ene | startinsert",
              },
              {
                icon = " ",
                key = "g",
                desc = "Find Text",
                action = ":lua Snacks.dashboard.pick('live_grep')",
              },
              {
                icon = " ",
                key = "r",
                desc = "Recent Files",
                action = ":lua Snacks.dashboard.pick('oldfiles')",
              },
              {
                icon = " ",
                key = "c",
                desc = "Config",
                action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})",
              },
              {
                icon = " ",
                key = "s",
                desc = "Restore Session",
                section = "session",
              },
              {
                icon = "󰒲 ",
                key = "L",
                desc = "Lazy",
                action = ":Lazy",
                enabled = package.loaded.lazy ~= nil,
              },
              { icon = " ", key = "q", desc = "Quit", action = ":q" },
            },
          },
        },
        words = { enabled = true },
      }
    end,
    init = function()
      local snacks = require("snacks")
      vim.api.nvim_create_autocmd("User", {
        pattern = "VeryLazy",
        callback = function()
          _G.dd = function(...)
            snacks.debug.inspect(...)
          end

          _G.dt = function(...)
            snacks.debug.backtrace(...)
          end
          vim.print = _G.dd
        end,
      })
    end,
    keys = {
      {
        "]r",
        function()
          require("snacks").words.jump(vim.v.count1)
        end,
        desc = "Next Reference",
        mode = { "n", "t" },
      },
      {
        "[r",
        function()
          require("snacks").words.jump(-vim.v.count1)
        end,
        desc = "Prev Reference",
        mode = { "n", "t" },
      },
    },
  },
  { "nmac427/guess-indent.nvim", opts = {}, event = { "BufReadPost", "BufNewFile" } },
  {
    "sphamba/smear-cursor.nvim",
    opts = function()
      local palette = require("catppuccin.palettes.mocha")
      return {
        cursor_color = palette.blue,
        normal_bg = palette.base,
      }
    end,
    event = { "BufNewFile", "BufReadPost", "FileType *" },
  },
  {
    "echasnovski/mini.animate",
    version = "*",
    init = function()
      vim.o.mousescroll = "ver:1,hor:6"
    end,
    priority = 1001,
    opts = function()
      local animate = require("mini.animate")
      return {
        cursor = { enable = false },
        scroll = {
          timing = animate.gen_timing.exponential({
            duration = 250,
            unit = "total",
            easing = "in-out",
          }),
        },
        resize = { enable = false },
        open = { enable = false },
        close = { enable = false },
      }
    end,
    event = { "BufNewFile", "BufReadPost", "FileType *" },
  },
  {
    "mistricky/codesnap.nvim",
    build = "make",
    version = "*",
    cond = function()
      return utils.no_vscode()
        and vim.fn.executable("make")
        and utils.platform() ~= "win"
    end,
    config = function(_, opts)
      if vim.fn.isdirectory(opts.save_path) ~= 1 then
        vim.fn.mkdir(opts.save_path, "p")
      end
      require("codesnap").setup(opts)
    end,
    opts = {
      mac_window_bar = false,
      save_path = vim.fn.expand("~/Pictures/nvim/"),
      has_breadcrumbs = true,
      has_line_number = true,
      show_workspace = false,
      watermark = "Davidyz @ github.com",
      bg_theme = "grape",
    },
    cmd = { "CodeSnap", "CodeSnapSave", "CodeSnapASCII" },
  },
  {
    "folke/todo-comments.nvim",
    config = true,
    keys = {
      {
        "<Leader>tt",
        "<cmd>TodoTelescope<CR>",
        mode = "n",
        desc = "[T]odo Comments.",
      },
      {
        "]t",
        function()
          require("todo-comments").jump_next()
        end,
        desc = "Next todo comment.",
      },
      {
        "[t",
        function()
          require("todo-comments").jump_prev()
        end,
        desc = "Previous todo comment.",
      },
    },
    event = { "BufReadPost", "BufNewFile" },
  },
  {
    "kawre/leetcode.nvim",
    cmd = "Leet",
    config = function()
      local lc = require("leetcode")
      local python_imports = {
        "# pyright: reportWildcardImportFromLibrary=false",
        "# pyright: reportUnusedClass=false",
        "# pyright: reportUnusedFunction=false",
        "# pyright: reportUnusedVariable=false",
      }
      local default_python_imports = require("leetcode.config.imports").python3
      for i, v in ipairs(default_python_imports) do
        if string.find(v, "import") ~= nil then
          default_python_imports[i] = v .. " # noqa: F401,F403"
        end
      end
      vim.list_extend(python_imports, default_python_imports)
      lc.setup({
        lang = "python3",
        injector = {
          ["python3"] = { before = python_imports },
        },
      })
    end,
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "nvim-lua/plenary.nvim", -- required by telescope
      "MunifTanjim/nui.nvim",

      -- optional
      "nvim-treesitter/nvim-treesitter",

      icon_provider,
    },
  },
  {
    "Zeioth/compiler.nvim",
    cmd = { "CompilerOpen", "CompilerToggleResults", "CompilerRedo" },
    keys = {
      {
        "<F6>",
        "<cmd>CompilerOpen<CR>",
        noremap = true,
        mode = { "n" },
        silent = true,
      },
      {
        "<S-F6>",
        "<cmd>CompilerStop<CR><cmd>CompilerRedo<CR>",
        noremap = true,
        mode = { "n" },
        silent = true,
      },
      {
        "<S-F7>",
        "<cmd>CompilerToggleResults<cr>",
        noremap = true,
        mode = { "n" },
        silent = true,
      },
    },
    dependencies = {
      {
        "stevearc/overseer.nvim",
        cmd = { "CompilerOpen", "CompilerToggleResults", "CompilerRedo" },
        opts = {
          task_list = {
            direction = "bottom",
            min_height = 25,
            max_height = 25,
            default_detail = 1,
            bindings = {
              ["<C-h>"] = nil,
              ["<C-j>"] = nil,
              ["<C-k>"] = nil,
              ["<C-l>"] = nil,
            },
          },
        },
      },
    },
    opts = {},
  },
  { "mawkler/modicator.nvim", opts = {}, event = { "BufReadPost", "BufNewFile" } },
  {
    "stevearc/dressing.nvim",
    opts = { input = { title_pos = "center", border = "rounded" } },
  },
  {
    "NStefan002/2048.nvim",
    cmd = "Play2048",
    config = true,
    opts = {
      keys = {
        up = "<Up>",
        down = "<Down>",
        left = "<Left>",
        right = "<Right>",
        undo = "<C-z>",
      },
    },
  },
  { "rktjmp/playtime.nvim", cmd = { "Playtime" }, opts = { fps = 60 } },
  {
    "lewis6991/hover.nvim",
    opts = {
      init = function()
        require("hover.providers.lsp")
        require("hover.providers.man")
        require("hover.providers.diagnostic")
      end,
      preview_opts = {
        -- border = "double",
      },
      preview_window = false,
      title = true,
      mouse_providers = {
        "LSP",
      },
      mouse_delay = 1000,
    },
    keys = {
      {
        "K",
        function()
          require("hover").hover()
        end,
        desc = "Trigger hover.",
        mode = "n",
        noremap = true,
      },
      {
        "[h",
        function()
          require("hover").hover_switch("previous")
        end,
        desc = "Previous hover provider.",
        mode = "n",
        noremap = true,
      },
      {
        "]h",
        function()
          require("hover").hover_switch("next")
        end,
        desc = "Next hover provider.",
        mode = "n",
        noremap = true,
      },
    },
  },
  {
    "brenoprata10/nvim-highlight-colors",
    config = function()
      require("nvim-highlight-colors").setup({
        render = "virtual",
        enable_tailwind = true,
      })
      require("nvim-highlight-colors").turnOn()
    end,
    event = { "BufReadPost", "BufNewFile" },
  },
  {
    "lewis6991/gitsigns.nvim",
    keys = {
      {
        "<Leader>gb",
        function()
          local gitsigns = require("gitsigns")
          gitsigns.toggle_current_line_blame()
          local msg = nil
          if require("gitsigns.config").config.current_line_blame then
            msg = "Enabled."
          else
            msg = "Disabled."
          end
          vim.notify(msg, "info", { title = "Git Blame" })
        end,
        noremap = true,
      },
    },
    opts = {
      signs = {},
      signs_staged = {
        add = { text = "" },
        change = { text = "" },
        delete = { text = "" },
        topdelete = { text = "‾" },
        changedelete = { text = ">" },
        untracked = { text = "┆" },
      },
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = "right_align",
        delay = 10,
        ignore_whitespace = false,
        virt_text_priority = 100,
      },
    },
    config = function(_, opts)
      require("gitsigns").setup(opts)
      vim.api.nvim_set_hl(0, "GitSignsCurrentLineBlame", { link = "Comment" })
    end,
    event = { "BufReadPost", "BufNewFile" },
  },
  { "nvim-lua/plenary.nvim" },
  {
    "smoka7/hop.nvim",
    opts = {},
    keys = {
      { "f", ":HopChar1<CR>", remap = false, mode = "n", desc = "Hop to character." },
      { "F", ":HopNodes<CR>", remap = false, mode = "n", desc = "Hop to node." },
    },
  },
  {
    "nvim-telescope/telescope.nvim",
    version = "*",
    keys = {
      {
        "<Leader>tf",
        function()
          require("telescope.builtin").find_files({
            layout_config = { prompt_position = "top", preview_width = 0.6 },
          })
        end,
        remap = false,
        mode = "n",
        desc = "Fuzzy find files.",
      },
      {
        "<Leader>tb",
        function()
          require("telescope.builtin").buffers({
            layout_config = { prompt_position = "top", preview_width = 0.6 },
          })
        end,
        remap = false,
        mode = "n",
        desc = "Show buffers.",
      },
      {
        "<Leader>tq",
        function()
          require("telescope.builtin").quickfix({
            layout_config = { prompt_position = "top", preview_width = 0.6 },
          })
        end,
        remap = false,
        mode = "n",
        desc = "Show quickfix.",
      },
      {
        "<Leader>tD",
        function()
          require("telescope.builtin").diagnostics({
            layout_config = { prompt_position = "top", preview_width = 0.6 },
          })
        end,
        remap = false,
        mode = "n",
        desc = "Project-wise diagnostics.",
      },
      {
        "<Leader>td",
        function()
          require("telescope.builtin").diagnostics({
            bufnr = 0,
            layout_config = { prompt_position = "top", preview_width = 0.6 },
          })
        end,
        remap = false,
        mode = "n",
        desc = "Buffer diagnostics.",
      },
      {
        "<Leader>th",
        function()
          require("telescope.builtin").help_tags({
            layout_config = { prompt_position = "top", preview_width = 0.6 },
          })
        end,
        remap = false,
        mode = "n",
        desc = "Find help tags.",
      },
      {
        "R",
        function()
          require("telescope.builtin").live_grep({
            layout_config = { prompt_position = "top", preview_width = 0.6 },
          })
        end,
        remap = false,
        mode = "n",
        desc = "Live grep.",
      },
      {
        "<Leader>f",
        function()
          require("telescope.builtin").current_buffer_fuzzy_find({
            layout_config = { prompt_position = "top", preview_width = 0.6 },
          })
        end,
        remap = false,
        mode = "n",
        desc = "Fuzzy find current buffer.",
      },
      {
        "<Leader>tr",
        function()
          require("telescope.builtin").resume()
        end,
        remap = false,
        mode = "n",
        desc = "Resume last telescope session",
      },
    },
    config = function(_, opts)
      require("telescope").setup(opts)
      require("telescope").load_extension("ui-select")
    end,
    cmd = "Telescope",
    opts = function()
      return {
        defaults = {
          layout_strategy = "horizontal",
          -- layout_config = { prompt_position = "top", preview_width = 0.6 },
          layout_config = { prompt_position = "top" },
          sorting_strategy = "ascending",
          mappings = {
            i = {
              ["<esc>"] = require("telescope.actions").close,
            },
          },
        },
        extensions = {
          ["ui-select"] = { require("telescope.themes").get_dropdown() },
        },
      }
    end,
    dependencies = {
      "nvim-telescope/telescope-fzf-native.nvim",
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-ui-select.nvim",
    },
  },
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = "make",
    cond = function()
      return utils.no_vscode() and vim.fn.executable("make") == 1
    end,
    config = function(_, opts)
      require("telescope").setup(opts)
      require("telescope").load_extension("fzf")
    end,
    opts = { extensions = { fzf = {} } },
  },
  {
    "debugloop/telescope-undo.nvim",
    dependencies = {
      {
        "nvim-telescope/telescope.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
      },
    },
    keys = {
      {
        "<leader>tu",
        "<cmd>Telescope undo<cr>",
        desc = "undo history",
      },
    },
    opts = {
      extensions = {
        undo = {
          use_delta = vim.fn.executable("delta") == 1,
          layout_strategy = "vertical",
          layout_config = {
            width = 0.8,
            height = 0.9,
            prompt_position = "top",
            preview_cutoff = 20,
            preview_height = function(_, _, max_lines)
              return max_lines - 15
            end,
          },
        },
      },
    },
    config = function(_, opts)
      require("telescope").setup(opts)
      require("telescope").load_extension("undo")
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    cond = utils.no_vscode,
    config = function()
      require("plugins._lualine")
    end,
    lazy = false,
    dependencies = { icon_provider },
  },
  {
    "shellRaining/hlchunk.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = function()
      local excluded_ft =
        { ["neo-tree"] = true, snacks_dashboard = true, fidget = true, help = true }
      local hl_names = {
        "RainbowDelimiterRed",
        "RainbowDelimiterYellow",
        "RainbowDelimiterBlue",
        "RainbowDelimiterOrange",
        "RainbowDelimiterGreen",
        "RainbowDelimiterViolet",
        "RainbowDelimiterCyan",
      }
      local hl_groups = {}
      for i, v in ipairs(hl_names) do
        hl_groups[i] = vim.api.nvim_get_hl(0, { name = v })
      end

      return {
        chunk = {
          delay = 100,
          enable = true,
          exclude_filetypes = excluded_ft,
          style = require("catppuccin.palettes.mocha").lavender,
        },
        indent = {
          enable = true,
          exclude_filetypes = excluded_ft,
        },
      }
    end,
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    cond = utils.no_vscode,
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    dependencies = {
      "3rd/image.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-lua/plenary.nvim",
    },
    init = function()
      vim.api.nvim_create_autocmd("BufEnter", {
        -- make a group to be able to delete it later
        group = vim.api.nvim_create_augroup("NeoTreeInit", { clear = true }),
        callback = function()
          local f = vim.fn.expand("%:p")
          if vim.fn.isdirectory(f) ~= 0 then
            vim.cmd("Neotree dir=" .. f)
            -- neo-tree is loaded now, delete the init autocmd
            vim.api.nvim_clear_autocmds({ group = "NeoTreeInit" })
          end
        end,
      })
    end,
    opts = {
      close_if_last_window = true,
      sort_case_insensitive = true,
      use_libuv_file_watcher = true,
      filesystem = {
        filtered_items = {
          visible = true,
          hide_hidden = false,
          hide_dotfiles = false,
        },
        follow_current_file = { enabled = true },
      },
      window = {
        mappings = {
          ["<cr>"] = "open",
          ["<left>"] = "navigate_up",
          ["<right>"] = "set_root",
          ["<space>"] = "open",
        },
      },
      buffers = {
        follow_current_file = { enabled = true },
      },
      source_selector = { show_scrolled_off_parent_node = true },
      default_component_configs = {
        icon = { folder_closed = "", folder_open = "" },
        git_status = { symbols = { added = "", modified = "" } },
      },
    },
    keys = {
      {
        "<Leader>T",
        "<cmd>Neotree action=focus toggle<cr>",
        mode = "n",
        remap = true,
      },
    },
  },
  {
    "stevearc/oil.nvim",
    version = "*",
    opts = { lsp_file_methods = { autosave_changes = true } },
    dependencies = { icon_provider },
    cmd = { "Oil" },
  },
  {
    "kylechui/nvim-surround",
    opts = {},
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
  },
  {
    "mtrajano/tssorter.nvim",
    version = "*",
    opts = {},
    keys = {
      {
        "<Leader>s",
        function()
          require("tssorter").sort({})
        end,
        mode = { "n", "x" },
        desc = "Sort selected treesitter nodes.",
      },
      {
        "<Leader>S",
        function()
          require("tssorter").sort({ reverse = true })
        end,
        mode = { "n", "x" },
        desc = "Sort selected treesitter nodes (reversed).",
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
  },
  {
    "nvim-focus/focus.nvim",
    opts = {},
    config = true,
    event = "WinNew",
    init = function()
      local ignore_filetypes = { "neo-tree", "Outline" }
      local ignore_buftypes = { "nofile", "prompt", "popup" }

      local augroup = vim.api.nvim_create_augroup("FocusDisable", { clear = true })

      vim.api.nvim_create_autocmd("WinEnter", {
        group = augroup,
        callback = function(_)
          if vim.tbl_contains(ignore_buftypes, vim.bo.buftype) then
            vim.w.focus_disable = true
          else
            vim.w.focus_disable = false
          end
        end,
        desc = "Disable focus autoresize for BufType",
      })

      vim.api.nvim_create_autocmd("FileType", {
        group = augroup,
        callback = function(_)
          if vim.tbl_contains(ignore_filetypes, vim.bo.filetype) then
            vim.b.focus_disable = true
          else
            vim.b.focus_disable = false
          end
        end,
        desc = "Disable focus autoresize for FileType",
      })
    end,
  },
  { "backdround/tabscope.nvim", config = true },
  {
    "akinsho/toggleterm.nvim",
    keys = {
      {
        "<C-\\>",
        '<Esc><Cmd>execute v:count . "ToggleTerm"<CR>',
        mode = { "i", "n" },
        desc = "Toggle terminal.",
      },
    },
    config = true,
    opts = {
      open_mapping = "<C-\\>",
    },
  },
  {
    "pappasam/nvim-repl",
    init = function()
      vim.g.repl_filetype_commands = { python = "ipython" }
      if vim.fn.executable("ipython") == 0 then
        vim.g.repl_filetype_commands.python = "python"
      end
      vim.g.repl_split = "bottom"
    end,
    keys = { { "<C-|>", "<cmd>ReplToggle<cr>", desc = "Toggle repl" } },
    cmd = { "Repl", "ReplOpen", "ReplRunCell" },
  },
  {
    "jim-fx/sudoku.nvim",
    cmd = "Sudoku",

    opts = {
      mappings = {
        { key = "1", action = "insert=1" },
        { key = "2", action = "insert=2" },
        { key = "3", action = "insert=3" },
        { key = "4", action = "insert=4" },
        { key = "5", action = "insert=5" },
        { key = "6", action = "insert=6" },
        { key = "7", action = "insert=7" },
        { key = "8", action = "insert=8" },
        { key = "9", action = "insert=9" },
        { key = "0", action = "clear_cell" },
      },
    },
  },
  {
    "wintermute-cell/gitignore.nvim",
    cmd = "Gitignore",
    dependencies = { "nvim-telescope/telescope.nvim" },
  },
  {
    "f-person/git-blame.nvim",
    keys = {
      {
        "<Leader>go",
        "<cmd>GitBlameOpenCommitURL<cr><cmd>GitBlameDisable<cr>",
        noremap = true,
      },
      {
        "<Leader>gc",
        "<cmd>GitBlameCopyCommitURL<cr><cmd>GitBlameDisable<cr>",
        noremap = true,
      },
    },
    init = function()
      vim.g.gitblame_enabled = 0
    end,
  },
  {
    "akinsho/git-conflict.nvim",
    config = true,
  },
  {
    "sindrets/diffview.nvim",
    config = true,
    cmd = { "DiffviewOpen", "DiffviewFileHistory" },
  },
  {
    "Davidyz/executable-checker.nvim",
    opts = {},
    event = "VeryLazy",
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
    "NStefan002/screenkey.nvim",
    config = true,
    cmd = "Screenkey",
    opts = {
      win_opts = {
        relative = "editor",
        anchor = "SE",
        width = 40,
        height = 3,
        border = "single",
      },
      compress_after = 3,
      clear_after = 3,
      disable = {
        filetypes = { "toggleterm" },
        buftypes = { "terminal" },
      },
    },
  },
  {
    "tris203/precognition.nvim",
    enabled = false,
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      showBlankVirtLine = false,
      gutterHints = {
        G = { prio = 0 },
        gg = { prio = 0 },
        PrevParagraph = { prio = 0 },
        NextParagraph = { prio = 0 },
      },
    },
  },
  {
    "keaising/im-select.nvim",
    cond = function()
      return utils.any(
        { "fcitx-remote", "fcitx5-remote", "im-select", "im-select.exe" },
        function(arg)
          return vim.fn.executable(arg) == 1
        end
      )
    end,
    main = "im_select",
    opts = {
      async_switch_im = false,
      set_previous_events = { "InsertEnter" },
    },
    cmd = { "BufReadPost", "BufNewFile" },
  },
  {
    "amitds1997/remote-nvim.nvim",
    cond = function()
      return utils.no_vscode() and utils.cpu_count() >= 2
    end,
    dependencies = {
      "nvim-lua/plenary.nvim", -- For standard functions
      "MunifTanjim/nui.nvim", -- To build the plugin UI
      "nvim-telescope/telescope.nvim", -- For picking b/w different remote methods
    },
    opt = {},
    config = true,
    cmd = {
      "RemoteCleanup",
      "RemoteConfigDel",
      "RemoteInfo",
      "RemoteLog",
      "RemoteStart",
    },
  },
  {
    "willothy/flatten.nvim",
    opts = { window = { open = "tab" } },
    lazy = false,
    priority = 1001,
  },
  {
    "David-Kunz/gen.nvim",
    cmd = { "Gen" },
    opts = {
      accept_map = "<c-cr>",
      debug = false,
      display_mode = "float",
      hidden = false,
      host = os.getenv("OLLAMA_ENTRY"),
      init = function(_) end,
      model = "deepseek-coder-v2:16b-lite-instruct-q5_K_M",
      no_auto_close = true,
      port = "11434",
      quit_map = "q",
      retry_map = "<c-r>",
      show_model = true,
      show_prompt = true, -- Prints errors and the command which is run.
    },
    cond = function()
      return utils.no_vscode()
        and (vim.fn.executable("ollama") == 1 or os.getenv("OLLAMA_ENTRY") ~= nil)
    end,
  },
  {
    "folke/which-key.nvim",
    event = "BufEnter",
    opts = {
      preset = "modern",
    },
    keys = {
      {
        "<leader>?",
        function()
          require("which-key").show({ global = false })
        end,
        desc = "Buffer Local Keymaps (which-key)",
      },
    },
    cond = utils.no_vscode(),
  },
  {
    "3rd/image.nvim",
    filetypes = { "markdown" },
    dependencies = { "leafo/magick" },
    cond = function()
      return vim.fn.executable("magick") == 1
        and utils.no_vscode()
        and utils.no_neovide()
        and vim.fn.executable("lua5.1") == 1
    end,
    opts = function()
      return {
        backend = "kitty",
        max_width_window_percentage = 200 / 3,
        integrations = {
          markdown = {
            clear_in_insert_mode = true,
            only_render_image_at_cursor = true,
          },
        },
        window_overlap_clear_enabled = true,
        editor_only_render_when_focused = true,
      }
    end,
  },
}

for _, spec in pairs(M.plugins) do
  if spec.dir ~= nil then
    spec.dir = vim.fn.expand(spec.dir)
  end
end

M.config = {
  defaults = { lazy = true },
  dev = { fallback = true },
  install = { colorscheme = { "catppuccin-mocha" } },
  profiling = { loader = true, require = true },
  ui = {
    border = "none",
    backdrop = 100,
  },
}

return M
