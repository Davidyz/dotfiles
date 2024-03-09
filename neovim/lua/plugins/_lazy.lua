M = {}
local utils = require("_utils")

---@type LazyPluginSpec[]
M.plugins = {
  -- filetypes
  {
    "stevearc/vim-arduino",
    ft = { "arduino" },
    lazy = true,
    cond = function()
      return vim.fn.executable("arduino-cli") ~= 0 and utils.no_vscode()
    end,
  },
  { "theRealCarneiro/hyprland-vim-syntax" },
  {
    "lervag/vimtex",
    ft = { "tex" },
    lazy = true,
    cond = utils.no_vscode,
    config = function()
      require("executable-checker").add_executable("zathura")
      require("executable-checker").add_executable("xdotool")
      require("executable-checker").add_executable("biber")
      vim.g.vimtex_quickfix_mode = 0

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
    lazy = true,
    cond = function()
      return vim.fn.executable("objdump") ~= 0
    end,
    event = "VeryLazy",
  },
  {
    "neovimhaskell/haskell-vim",
    ft = { "haskell", "hs" },
    lazy = true,
    config = function()
      require("plugins.haskell")
    end,
    event = "VeryLazy",
  },
  {
    "chrisbra/csv.vim",
    lazy = true,
    ft = { "csv" },
    event = "VeryLazy",
  },
  {
    "goerz/jupytext.vim",
    lazy = true,
    ft = { "jupyter", "notebook", "ipynb", "py", "json" },
    cond = utils.no_vscode,
    config = function()
      require("plugins.jupytext")
    end,
    event = "VeryLazy",
  },
  {
    "lark-parser/vim-lark-syntax",
    ft = { "lark" },
    lazy = true,
    event = "VeryLazy",
  },
  {
    "vim-scripts/cup.vim",
    lazy = true,
    ft = { "cup" },
    event = "VeryLazy",
  },
  {
    "udalov/javap-vim",
    lazy = true,
    ft = { "javap" },
    event = "VeryLazy",
  },
  {
    "cespare/vim-toml",
    lazy = true,
    branch = "main",
    ft = { "toml" },
    event = "VeryLazy",
  },
  {
    "mikelue/vim-maven-plugin",
    lazy = true,
    ft = {
      "maven",
      "xml",
    },
    event = "VeryLazy",
  },
  {
    "vim-scripts/crontab.vim",
    lazy = true,
    ft = { "crontab" },
    event = "VeryLazy",
  },

  -- markdown
  {
    "mzlogin/vim-markdown-toc",
    event = "VeryLazy",
    lazy = true,
    ft = { "markdown", "pandoc" },
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
    "olimorris/onedarkpro.nvim",
    priority = 100,
    config = function()
      local onedark = require("onedarkpro")
      onedark.setup({
        colors = { onedark = { bg = "#0F111A" } },
        highlights = {},
        theme = "onedark",
        styles = {
          strings = "NONE",
          comments = "italic",
          keywords = "NONE",
          functions = "NONE",
          variables = "NONE",
          virtual_text = "NONE",
          types = "bold",
        },
        options = {
          bold = true,
          italic = true,
          underline = true,
          undercurl = true,
          cursorline = true,
          transparency = true,
          terminal_colors = true,
          highlight_inactive_windows = true,
        },
        plugins = { treesitter = true },
      })
      onedark.load()
    end,
    enabled = true,
    cond = utils.no_vscode,
  },
  {
    "Mofiqul/vscode.nvim",
    config = function()
      require("vscode").setup({
        transparent = true,
        italic_comments = true,
        disable_nvimtree_bg = true,
      })
      require("vscode").load()
    end,
    enabled = false,
  },

  -- tree sitter
  {
    "nvim-treesitter/nvim-treesitter",
    config = function(config, opts)
      require("plugins.tree_sitter")
    end,
    build = ":TSUpdate",
    event = "VeryLazy",
    cond = utils.no_vscode,
  },
  {
    "nvim-treesitter/playground",
    event = "VeryLazy",
    cond = utils.no_vscode,
  },
  {
    "nvim-treesitter/nvim-treesitter-refactor",
    event = "VeryLazy",
    cond = utils.no_vscode,
  },
  {
    "windwp/nvim-autopairs",
    cond = utils.no_vscode,
    config = function()
      require("plugins.nvim_autopairs")
    end,
    event = "VeryLazy",
  },
  {
    "monkoose/matchparen.nvim",
    config = true,
    cond = utils.no_vscode,
  },
  {
    "RRethy/vim-illuminate",
    cond = utils.no_vscode,
    event = "VeryLazy",
    config = function()
      require("illuminate").configure({
        providers = { "treesitter", "lsp" },
      })
      vim.api.nvim_set_hl(0, "illuminatedWordText", { link = "MatchParen" })
      vim.api.nvim_set_hl(0, "IlluminatedWordRead", { link = "MatchParen" })
      vim.api.nvim_set_hl(0, "IlluminatedWordWrite", { link = "MatchParen" })
    end,
  },

  -- mason
  {
    "williamboman/mason.nvim",
    cmd = { "Mason" },
    lazy = true,
    opts = {
      ui = { border = "double" },
      max_concurrent_jobs = math.min(4, utils.cpu_count()),
      PATH = "append",
    },
    event = "VeryLazy",
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    config = function()
      require("plugins.mason_tools")
    end,
    event = "VeryLazy",
  },
  {
    "nvimtools/none-ls.nvim",
    config = require("plugins.null_ls"),
    event = "VeryLazy",
  },
  {
    "jay-babu/mason-null-ls.nvim",
    event = { "BufReadPre", "BufNewFile" },
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

  -- lsp
  {
    "neovim/nvim-lspconfig",
    config = function()
      require("mason").setup()
      require("plugins._lsp")
      require("keymaps._lsp")
    end,
    cond = utils.no_vscode,
    --dependencies = { "folke/neodev.nvim" },
  },
  {
    "hrsh7th/nvim-cmp",
    cond = utils.no_vscode,
  },
  {
    "hrsh7th/cmp-nvim-lsp",
    event = "LspAttach",
    cond = utils.no_vscode,
  },
  {
    "hrsh7th/cmp-buffer",
    event = "LspAttach",
    cond = utils.no_vscode,
  },
  {
    "hrsh7th/cmp-path",
    event = "LspAttach",
    cond = utils.no_vscode,
  },
  {
    "hrsh7th/cmp-cmdline",
    event = "LspAttach",
    cond = utils.no_vscode,
  },
  {
    "hrsh7th/cmp-nvim-lua",
    event = "LspAttach",
    cond = utils.no_vscode,
  },
  {
    "DasGandlaf/nvim-autohotkey",
    ft = { "autohotkey" },
    config = function()
      require("nvim-autohotkey")
    end,
  },
  {
    "L3MON4D3/LuaSnip",
    config = function()
      require("plugins.snippets")
      require("keymaps.snippets")
    end,
    cond = utils.no_vscode,
  },
  {
    "saadparwaiz1/cmp_luasnip",
    cond = utils.no_vscode,
  },
  {
    "rafamadriz/friendly-snippets",
    cond = utils.no_vscode,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    cond = utils.no_vscode,
    event = "VeryLazy",
    --dependencies = { "folke/neodev.nvim" },
  },
  {
    "hrsh7th/cmp-nvim-lsp-signature-help",
    event = "LspAttach",
    cond = utils.no_vscode,
  },
  {
    "SmiteshP/nvim-navic",
    config = true,
    event = "LspAttach",
    cond = utils.no_vscode,
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
  },
  {
    "j-hui/fidget.nvim",
    event = "LspAttach",
    config = function()
      vim.api.nvim_set_hl(0, "FidgetTitle", { link = "Exception" })
      vim.api.nvim_set_hl(0, "FidgetTask", { link = "Tag" })
      require("fidget").setup({
        notification = {
          window = {
            winblend = 0,
            border = "rounded",
            align = "bottom",
          },
          view = { stack_upwards = false },
        },
      })
    end,
    cond = utils.no_vscode,
  },
  {
    "Davidyz/lsp-location-handler.nvim",
    config = true,
    cond = utils.no_vscode,
    event = "LspAttach",
  },
  {
    "folke/neodev.nvim",
    event = "LspAttach",
    ft = { "lua" },
    lazy = true,
    config = true,
    cond = utils.no_vscode,
  },
  {
    "aznhe21/actions-preview.nvim",
    keys = { "<Leader>a" },
    lazy = true,
    config = function()
      vim.keymap.set({ "v", "n" }, "<Leader>a", require("actions-preview").code_actions)
      require("actions-preview").setup({
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
      })
    end,
    cond = utils.no_vscode,
  },
  {
    "ThePrimeagen/refactoring.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    cond = utils.no_vscode,
    config = function()
      require("refactoring").setup({
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

      vim.keymap.set("x", "<leader>ef", function()
        require("refactoring").refactor("Extract Function")
      end)
      vim.keymap.set("x", "<leader>ev", function()
        require("refactoring").refactor("Extract Variable")
      end)
    end,
    event = "LspAttach",
    keys = { "<leader>ef", "<leader>ev" },
    lazy = true,
  },
  {
    "zbirenbaum/copilot.lua",
    event = "LspAttach",
    opts = {
      suggestion = { enabled = false },
      panel = { enabled = false },
    },
    cond = utils.no_vscode,
  },
  {
    "zbirenbaum/copilot-cmp",
    config = true,
    cond = utils.no_vscode,
  },
  {
    "onsails/lspkind.nvim",
    cond = utils.no_vscode,
    event = "LspAttach",
    config = function()
      local lspkind = require("lspkind")
      local cmp = require("cmp")
      cmp.setup({
        formatting = {
          format = lspkind.cmp_format({
            mode = "symbol_text",
            maxwidth = 50,
            ellipsis_char = "...",
          }),
        },
      })
    end,
  },
  {
    "kevinhwang91/nvim-ufo",
    dependencies = "kevinhwang91/promise-async",
    cond = utils.no_vscode,
    config = function()
      require("plugins._ufo")
    end,
    event = "LspAttach",
  },
  {
    "hedyhli/outline.nvim",
    cond = utils.no_vscode,
    cmd = { "Outline", "OutlineOpen" },
    keys = { -- Example mapping to toggle outline
      { "<leader>o", ":Outline<CR>", desc = "Toggle outline" },
    },
    opts = {},
    config = function()
      local outline = require("outline")
      outline.setup()
      vim.keymap.set("n", "<Leader-o>", outline.toggle, { desc = "Toggle outline" })
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
    event = "VeryLazy",
    dependencies = "neovim/nvim-lspconfig",
    opts = { excluded_lsp_clients = { "null-ls" } },
  },

  -- dap
  {
    "mfussenegger/nvim-dap",
    cond = utils.no_vscode,
    lazy = true,
    config = function()
      require("plugins.dap")
      require("keymaps.dap")
    end,
    event = "VeryLazy",
  },
  {
    "theHamsta/nvim-dap-virtual-text",
    cond = utils.no_vscode,
    event = "VeryLazy",
    lazy = true,
  },
  {
    "rcarriga/nvim-dap-ui",
    cond = utils.no_vscode,
    event = "VeryLazy",
    lazy = true,
  },
  {
    "jbyuki/one-small-step-for-vimkind",
    lazy = true,
    cond = utils.no_vscode,
    event = "VeryLazy",
  },
  {
    "mfussenegger/nvim-jdtls",
    ft = { "java" },
    cond = utils.no_vscode,
    event = "VeryLazy",
    lazy = true,
  },
  {
    "jay-babu/mason-nvim-dap.nvim",
    cond = utils.no_vscode,
    event = "VeryLazy",
    lazy = true,
  },

  -- misc
  -- "~/git/fauxpilot.nvim",
  -- "github/copilot.vim",
  --{ "altermo/nxwm" },

  {
    "stevearc/dressing.nvim",
    opts = { input = { border = "rounded" } },
  },
  {
    "NStefan002/2048.nvim",
    lazy = true,
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
  {
    "gorbit99/codewindow.nvim",
    config = function()
      local codewindow = require("codewindow")
      codewindow.setup({ window_border = "double" })
      codewindow.apply_default_keybinds()
    end,
    lazy = true,
  },
  {
    "lewis6991/hover.nvim",
    config = function()
      require("hover").setup({
        init = function()
          -- Require providers
          require("hover.providers.lsp")
          -- require('hover.providers.gh')
          -- require('hover.providers.gh_user')
          -- require('hover.providers.jira')
          require("hover.providers.man")
          -- require("hover.providers.dictionary")
        end,
        preview_opts = {
          border = "double",
        },
        -- Whether the contents of a currently open hover window should be moved
        -- to a :h preview-window when pressing the hover keymap.
        preview_window = false,
        title = true,

        mouse_providers = {
          "LSP",
        },
        mouse_delay = 1000,
      })

      -- Setup keymaps
      vim.keymap.set("n", "K", require("hover").hover, { desc = "hover.nvim" })
      vim.keymap.set(
        "n",
        "<MouseMove>",
        require("hover").hover_mouse,
        { desc = "hover.nvim (mouse)" }
      )
      vim.o.mousemoveevent = true
    end,
    lazy = true,
    keys = { "K" },
  },
  {
    "brenoprata10/nvim-highlight-colors",
    config = function()
      require("nvim-highlight-colors.color.patterns").hex_regex =
        "#[%a%d][%a%d][%a%d][%a%d][%a%d][%a%d]"
      require("nvim-highlight-colors").turnOn()
    end,
    event = "VeryLazy",
  },
  {
    "ethanholz/nvim-lastplace",
    opts = {
      lastplace_ignore_buftype = { "quickfix", "nofile", "help" },
      lastplace_ignore_filetype = {
        "gitcommit",
        "gitrebase",
        "svn",
        "hgcommit",
      },
      lastplace_open_folds = true,
    },
    config = true,
    event = "VeryLazy",
    lazy = true,
  },
  {
    "lewis6991/gitsigns.nvim",
    branch = "release",
    opts = {
      signs = {
        add = { text = "+" },
        change = { text = "~" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = ">" },
        untracked = { text = "┆" },
      },
    },
    event = "VeryLazy",
  },
  { "nvim-lua/plenary.nvim", event = "VeryLazy" },
  {
    "smoka7/hop.nvim",
    lazy = true,
    config = function()
      local hop = require("hop")
      local directions = require("hop.hint").HintDirection
      vim.keymap.set("", "f", function()
        hop.hint_char1({
          direction = directions.AFTER_CURSOR,
          current_line_only = true,
        })
      end, { remap = true })
      vim.keymap.set("", "F", function()
        hop.hint_char1({
          direction = directions.BEFORE_CURSOR,
          current_line_only = true,
        })
      end, { remap = true })
      vim.keymap.set("", "t", function()
        hop.hint_char1({
          direction = directions.AFTER_CURSOR,
          current_line_only = true,
          hint_offset = -1,
        })
      end, { remap = true })
      vim.keymap.set("", "T", function()
        hop.hint_char1({
          direction = directions.BEFORE_CURSOR,
          current_line_only = true,
          hint_offset = 1,
        })
      end, { remap = true })
      hop.setup({})
    end,
    keys = { "f", "F", "t", "T" },
  },
  {
    "nvim-telescope/telescope.nvim",
    event = "VeryLazy",
    config = function()
      require("keymaps.telescope")
    end,
  },
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
    cond = function()
      return utils.no_vscode() and vim.fn.executable("cmake") == 1
    end,
    config = function()
      require("telescope").setup({
        extensions = {
          fzf = {
            fuzzy = true, -- false will only do exact matching
            override_generic_sorter = true, -- override the generic sorter
            override_file_sorter = true, -- override the file sorter
            case_mode = "smart_case", -- or "ignore_case" or "respect_case"
            -- the default case_mode is "smart_case"
          },
        },
      })
      require("telescope").load_extension("fzf")
    end,
  },
  { "kyazdani42/nvim-web-devicons", dependencies = { "nvim-lualine/lualine.nvim" } },
  {
    "nvim-lualine/lualine.nvim",
    cond = utils.no_vscode,
    config = function()
      require("plugins._lualine")
    end,
  },
  { "itchyny/vim-gitbranch", event = "VeryLazy" },
  {
    "hiphish/rainbow-delimiters.nvim",
    --event = "VeryLazy",
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
        --priority = {
        --[""] = 110,
        --lua = 210,
        --},
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
    end,
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    config = function()
      vim.g.indent_blankline_filetype_exclude =
        { "startify", "help", "nerdtree", "alpha" }
      require("ibl").setup({
        -- for example, context is off by default, use this to turn it on
        exclude = {
          filetypes = { "startify", "help", "nerdtree", "alpha" },
        },
        scope = {
          enabled = true,
          show_exact_scope = false,
          show_start = false,
          show_end = false,
        },
      })
    end,
    event = "VeryLazy",
  },
  {
    "terrortylor/nvim-comment",
    cmd = { "CommentToggle" },
    main = "nvim_comment",
    config = function()
      require("nvim_comment").setup({
        marker_padding = true,
        comment_empty = false,
        comment_empty_trim_whitespace = true,
        create_mappings = false,
        line_mapping = nil,
        operator_mapping = nil,
        comment_chunk_text_object = "nil",
        hook = nil,
      })
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "arduino",
        callback = function()
          vim.bo.commentstring = "// %s"
        end,
      })
    end,
    keys = { { "<Leader>c<Space>", ":CommentToggle<CR>", mode = { "n", "v" } } },
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v2.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
    },
    config = function()
      local neotree = require("neo-tree")
      neotree.setup({
        close_if_last_window = true,
        sort_case_insensitive = true,
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
          follow_current_file = true,
        },
        source_selector = { show_scrolled_off_parent_node = true },
      })
      vim.api.nvim_set_keymap("n", "<Leader>t", "", {
        noremap = true,
        callback = function()
          neotree.focus("", true, true)
        end,
      })
    end,
  },
  {
    "kylechui/nvim-surround",
    config = true,
    event = "VeryLazy",
  },
  {
    "declancm/cinnamon.nvim",
    opts = {},
    event = "VeryLazy",
  },
  { "chaoren/vim-wordmotion", event = "VeryLazy" },
  { "ryanoasis/vim-devicons", event = "VeryLazy" },
  { "vim-scripts/restore_view.vim", event = "VeryLazy" },
  {
    "zhaocai/GoldenView.Vim",
    cond = utils.no_vscode,
    config = function()
      require("plugins.golden_view")
      require("keymaps.golden_view")
    end,
  },
  {
    dir = "Davidyz/make.nvim",
  },
  {
    "Davidyz/md-code.nvim",
    ft = { "markdown" },
    cond = utils.no_vscode,
    lazy = true,
    event = "VeryLazy",
    config = function()
      require("md-code")
    end,
  },
  {
    "dstein64/vim-startuptime",
    lazy = true,
  },
  { "ColaMint/pokemon.nvim", event = "VeryLazy" },
  lazy = true,
  {
    "goolord/alpha-nvim",
    config = function()
      require("plugins.alpha")
    end,
    dependencies = { "ColaMint/pokemon.nvim" },
  },
  { "backdround/tabscope.nvim", config = true },
  {
    "gpanders/editorconfig.nvim",
    cond = function()
      return vim.version().major < 1 and vim.version().minor < 9
    end,
    event = "VeryLazy",
  },
  {
    "akinsho/toggleterm.nvim",
    event = "VeryLazy",
    keys = { "<C-\\>" },
    lazy = true,
    opts = {
      open_mapping = "<C-\\>",
      direction = "horizontal",
      float_opts = {
        border = "curved",
      },
    },
  },
  {
    "jim-fx/sudoku.nvim",
    cmd = "Sudoku",
    lazy = true,
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
    event = "VeryLazy",
  },
  -- {
  --   "folke/which-key.nvim",
  --   config = function()
  --     vim.o.timeout = true
  --     vim.o.timeoutlen = 300
  --     require("which-key").setup({
  --       window = {
  --         border = "rounded",
  --         margin = { 1, math.floor(2 * vim.o.winwidth / 3), 1, 1 },
  --       },
  --       layout = { aligh = "left" },
  --     })
  --   end,
  -- },
  {
    "wintermute-cell/gitignore.nvim",
    cmd = "Gitignore",
    lazy = true,
    dependencies = { "nvim-telescope/telescope.nvim" },
  },
  {
    "f-person/git-blame.nvim",
    lazy = true,
    keys = { "<Leader>gb", "<Leader>go", "<Leader>gc" },
    config = function()
      local gb = require("gitblame")
      vim.g.gitblame_enabled = 0
      vim.keymap.set("n", "<Leader>gb", gb.toggle, { noremap = true })
      vim.keymap.set("n", "<Leader>go", function()
        gb.open_commit_url()
        gb.disable()
      end, { noremap = true })
      vim.keymap.set("n", "<Leader>gc", function()
        gb.copy_commit_url_to_clipboard()
        gb.disable()
      end, { noremap = true })
    end,
  },
  { "akinsho/git-conflict.nvim", version = "*", config = true },
  { "sindrets/diffview.nvim", config = true },
  {
    "Davidyz/executable-checker.nvim",
    config = true,
    opts = { executables = { "rg", "node" } },
  },
  {
    "3rd/image.nvim",
    filetypes = { "markdown" },
    build = "luarocks --local --lua-version 5.1 install magick",
    cond = function()
      package.path = package.path
        .. ";"
        .. vim.fn.expand("$HOME")
        .. "/.luarocks/share/lua/5.1/?/init.lua;"
      package.path = package.path
        .. ";"
        .. vim.fn.expand("$HOME")
        .. "/.luarocks/share/lua/5.1/?.lua;"
      local ok, _ = pcall(require, "magick")
      return ok and vim.fn.executable("magick") ~= 0 and utils.no_vscode()
    end,
    config = function()
      package.path = package.path
        .. ";"
        .. vim.fn.expand("$HOME")
        .. "/.luarocks/share/lua/5.1/?/init.lua;"
      package.path = package.path
        .. ";"
        .. vim.fn.expand("$HOME")
        .. "/.luarocks/share/lua/5.1/?.lua;"
      require("image").setup({
        backend = "kitty",
        max_width_window_percentage = 200 / 3,
        integrations = {
          markdown = {
            clear_in_insert_mode = true,
          },
        },
      })
    end,
    enabled = false,
  },
}

M.config = {
  ui = {
    border = "double",
  },
}

return M
