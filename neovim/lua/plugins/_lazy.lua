M = {}
local utils = require("_utils")

local icon_provider = "echasnovski/mini.icons"
---@type LazyPluginSpec[]
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
    "mzlogin/vim-markdown-toc",
    ft = { "markdown", "pandoc" },
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
      local cat = require("catppuccin.palettes." .. flavour)
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
          hop = true,
          lspsaga = true,
          mason = true,
          neotree = true,
          navic = { enabled = true },
          notify = true,
          which_key = true,
          nvim_surround = true,
          rainbow_delimiters = true,
          headlines = true,
          mini = { enabled = true },
        },
      }
    end,
  },
  {
    "lukas-reineke/headlines.nvim",
    dependencies = "nvim-treesitter/nvim-treesitter",
    opts = {},
    ft = { "markdown", "tex" },
  },

  -- NOTE: tree sitter
  {
    "nvim-treesitter/nvim-treesitter",
    config = function(config, opts)
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
      vim.g.matchup_matchparen_offscreen = { method = "popup" }
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
        table.insert(result, { " ⋯ ", "NonText" })
        table.insert(result, { suffix, "TSPunctBracket" })
        return result
      end,
      provider_selector = function(bufnum, filetype, buftype)
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
          return { "treesitter", "lsp" }
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
  {
    "antosha417/nvim-lsp-file-operations",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-neo-tree/neo-tree.nvim",
    },
    opts = {},
    event = { "LspAttach" },
    ft = { "neo-tree" },
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
    ---@type MasonSettings
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
      require("mason-tool-installer").clean()
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
    config = function()
      require("plugins._lsp")
      require("keymaps._lsp")
      require("lspconfig.ui.windows").default_options.border = { " " }
    end,
    event = { "BufReadPost", "BufNewFile" },
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
    "hrsh7th/nvim-cmp",
    cond = utils.no_vscode,
    opts = function()
      return require("keymaps.cmp")
    end,
    dependencies = {
      "brenoprata10/nvim-highlight-colors",
      "lukas-reineke/cmp-under-comparator",
    },
  },
  {
    "hrsh7th/cmp-nvim-lsp",
    event = "LspAttach",
    cond = utils.no_vscode,
  },
  {
    "hrsh7th/cmp-buffer",
    event = { "BufReadPost", "BufNewFile" },
    cond = utils.no_vscode,
    config = function()
      local cmp = require("cmp")
      cmp.setup.cmdline({ "/", "?" }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = "buffer" },
        },
      })
    end,
  },
  {
    "hrsh7th/cmp-path",
    event = { "BufReadPost", "BufNewFile" },
    cond = utils.no_vscode,
  },
  {
    "hrsh7th/cmp-cmdline",
    event = "BufEnter",
    -- event = { "CmdlineChanged", "CmdlineEnter" },
    cond = utils.no_vscode,
    dependencies = { "hrsh7th/nvim-cmp" },
    config = function()
      local cmp = require("cmp")
      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = "path" },

          { name = "cmdline" },
        }),
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
    event = { "BufReadPost", "BufNewFile" },
    opts = { friendly_snippets = true },
    config = function(_, opts)
      require("snippets").setup(opts)
    end,
    dependencies = { "rafamadriz/friendly-snippets" },
    cond = utils.no_vscode,
  },
  {
    "hrsh7th/cmp-nvim-lsp-signature-help",
    event = "LspAttach",
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
    event = "LspAttach",
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
  { "hrsh7th/cmp-emoji", event = "LspAttach" },
  { "kdheepak/cmp-latex-symbols", event = "LspAttach" },
  {
    "j-hui/fidget.nvim",
    event = "LspAttach",
    opts = {
      notification = {
        window = {
          normal_hl = "TelescopeBorder",
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
    },
  },
  {
    "hedyhli/outline.nvim",
    cond = utils.no_vscode,
    cmd = { "Outline", "OutlineOpen" },
    keys = {
      { "<leader>o", ":Outline<CR>", desc = "Toggle outline" },
    },
    opts = {},
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
    "Zeioth/garbage-day.nvim",
    event = "LspAttach",
    dependencies = "neovim/nvim-lspconfig",
    opts = { excluded_lsp_clients = { "null-ls" } },
  },
  {
    "folke/lazydev.nvim",
    event = "LspAttach",
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
    dependencies = { "neovim/nvim-lspconfig" },
    cmd = { "VenvSelect", "VenvSelectCurrent" },
    opts = { auto_refresh = true, name = { "venv", ".venv" } },
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
    "rcarriga/nvim-notify",
    config = function(_, opts)
      require("notify").setup(opts)
      vim.notify = require("notify")
    end,
    opts = {
      fps = 60,
      render = "compact",
      background_colour = "Normal",
      stages = "slide",
    },
    event = "BufEnter",
  },
  { "nmac427/guess-indent.nvim", opts = {}, event = { "BufReadPost", "BufNewFile" } },
  {
    "echasnovski/mini.animate",
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
    cond = function()
      return utils.no_vscode() and vim.fn.executable("make")
    end,
    init = function()
      local path = vim.fn.expand("~/Pictures/nvim/")
      if vim.fn.isdirectory(path) ~= 1 then
        vim.fn.mkdir(path, "p")
      end
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
      "rcarriga/nvim-notify",

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
    event = "VeryLazy",
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
          local notify = require("notify")
          notify(msg, "info", { title = "Git Blame" })
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
    keys = {
      {
        "<Leader>tf",
        "<cmd>Telescope find_files<cr>",
        remap = false,
        mode = "n",
      },
      {
        "<Leader>tb",
        "<cmd>Telescope buffers<cr>",
        remap = false,
        mode = "n",
      },
      {
        "<Leader>tq",
        "<cmd>Telescope quickfix<cr>",
        remap = false,
        mode = "n",
      },
      {
        "<Leader>tD",
        function()
          require("telescope.builtin").diagnostics()
        end,
        remap = false,
        mode = "n",
        desc = "Project-wise diagnostics.",
      },
      {
        "<Leader>td",
        function()
          require("telescope.builtin").diagnostics({ bufnr = 0 })
        end,
        remap = false,
        mode = "n",
        desc = "Buffer diagnostics.",
      },
      {
        "<Leader>th",
        "<cmd>Telescope help_tags<cr>",
        remap = false,
        mode = "n",
      },
      {
        "R",
        "<cmd>Telescope live_grep<cr>",
        remap = false,
        mode = "n",
      },
      {
        "<Leader>f",
        function()
          require("telescope.builtin").current_buffer_fuzzy_find()
        end,
        remap = false,
        mode = "n",
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
      return utils.no_vscode() and vim.fn.executable("cmake") == 1
    end,
    config = function()
      require("telescope").load_extension("fzf")
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
    "lukas-reineke/indent-blankline.nvim",
    event = { "LspAttach" },
    main = "ibl",
    init = function()
      vim.g.indent_blankline_filetype_exclude =
        { "startify", "help", "nerdtree", "Outline", "dashboard" }
    end,
    opts = {
      exclude = {
        filetypes = { "help", "neo-tree", "dashboard" },
      },
      scope = {
        enabled = true,
        show_exact_scope = false,
        show_start = false,
        show_end = false,
        include = { node_type = { ["*"] = "*" } },
        highlight = "@character.special",
      },
    },
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    event = "VimEnter",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "3rd/image.nvim",
    },
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
          ["<space>"] = "open",
          ["<left>"] = "navigate_up",
          ["<right>"] = "set_root",
        },
      },
      buffers = {
        follow_current_file = { enabled = true },
      },
      source_selector = { show_scrolled_off_parent_node = true },
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
        mode = "x",
        desc = "Sort selected treesitter nodes.",
      },
      {
        "<Leader>S",
        function()
          require("tssorter").sort({ reverse = true })
        end,
        mode = "x",
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

  {
    "nvimdev/dashboard-nvim",
    event = "BufEnter",
    config = function()
      require("dashboard").setup({
        shortcut_type = "number",
        theme = "hyper",

        change_to_vcs_root = true,
        hide = { tabline = false, statusline = false },
        config = {
          mru = { limit = 10, cwd_only = true },
          project = { enable = true },
          shortcut = {
            {
              desc = "Find file",
              key = "f",
              action = function()
                require("telescope.builtin").find_files()
              end,
            },
            {
              desc = "Live grep",
              key = "r",
              action = function()
                require("telescope.builtin").live_grep()
              end,
            },
            {
              desc = "Man pages",
              key = "m",
              action = function()
                require("telescope.builtin").man_pages()
              end,
            },
            {
              desc = "vim help",
              key = "h",
              action = function()
                require("telescope.builtin").help_tags()
              end,
            },
          },
        },
      })
      vim.api.nvim_set_hl(0, "DashboardFiles", { link = "@keyword" })
      vim.api.nvim_set_hl(0, "DashboardProjectTitle", { link = "Keyword" })
      vim.api.nvim_set_hl(0, "DashboardMruTitle", { link = "Keyword" })
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "dashboard",
        callback = function()
          vim.api.nvim_buf_set_keymap(0, "n", "q", ":exit<CR>", { noremap = true })
        end,
      })
    end,
    dependencies = { { icon_provider } },
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
  { "sindrets/diffview.nvim", config = true, cmd = { "DiffviewOpen" } },
  {
    "Davidyz/executable-checker.nvim",
    opts = {},
    event = "VeryLazy",
  },
  {
    "Sam-programs/cmdline-hl.nvim",
    event = "CmdlineChanged",
    opts = { inline_ghost_text = false },
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
      -- startVisible = true,
      showBlankVirtLine = false,
      -- highlightColor = { link = "Comment" },
      -- hints = {
      --      Caret = { text = "^", prio = 2 },
      --      Dollar = { text = "$", prio = 1 },
      --      MatchingPair = { text = "%", prio = 5 },
      --      Zero = { text = "0", prio = 1 },
      --      w = { text = "w", prio = 10 },
      --      b = { text = "b", prio = 9 },
      --      e = { text = "e", prio = 8 },
      --      W = { text = "W", prio = 7 },
      --      B = { text = "B", prio = 6 },
      --      E = { text = "E", prio = 5 },
      -- },
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
        { "fcitx5-remote", "fcitx-remote", "im-select", "im-select.exe" },
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
      "RemoteStart",
      "RemoteInfo",
      "RemoteCleanup",
      "RemoteLog",
      "RemoteConfigDel",
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
      model = "deepseek-coder-v2:16b-lite-instruct-q8_0",
      quit_map = "q",
      retry_map = "<c-r>",
      accept_map = "<c-cr>",
      host = os.getenv("OLLAMA_ENTRY"),
      port = "11434",
      display_mode = "float",
      show_prompt = true,
      show_model = true,
      no_auto_close = true,
      hidden = false,
      init = function(options) end,
      debug = false, -- Prints errors and the command which is run.
    },
    cond = function()
      return utils.no_vscode()
        and (vim.fn.executable("ollama") == 1 or os.getenv("OLLAMA_ENTRY") ~= nil)
    end,
  },
  -- {
  --   "3rd/image.nvim",
  --   filetypes = { "markdown" },
  --   build = "luarocks --local --lua-version 5.1 install magick",
  --   cond = function()
  --     package.path = package.path
  --       .. ";"
  --       .. vim.fn.expand("$HOME")
  --       .. "/.luarocks/share/lua/5.1/?/init.lua;"
  --     package.path = package.path
  --       .. ";"
  --       .. vim.fn.expand("$HOME")
  --       .. "/.luarocks/share/lua/5.1/?.lua;"
  --     local ok, _ = pcall(require, "magick")
  --     return ok and vim.fn.executable("magick") ~= 0 and utils.no_vscode()
  --   end,
  --   config = function()
  --     package.path = package.path
  --       .. ";"
  --       .. vim.fn.expand("$HOME")
  --       .. "/.luarocks/share/lua/5.1/?/init.lua;"
  --     package.path = package.path
  --       .. ";"
  --       .. vim.fn.expand("$HOME")
  --       .. "/.luarocks/share/lua/5.1/?.lua;"
  --     require("image").setup({
  --       backend = "kitty",
  --       max_width_window_percentage = 200 / 3,
  --       integrations = {
  --         markdown = {
  --           clear_in_insert_mode = true,
  --         },
  --       },
  --     })
  --   end,
  -- },
}

for _, spec in pairs(M.plugins) do
  if spec.dir ~= nil then
    spec.dir = vim.fn.expand(spec.dir)
  end
end

---@type LazyConfig
M.config = {
  defaults = { lazy = true },
  ui = {
    border = "double",
  },
  profiling = { loader = true, require = true },
}

return M
