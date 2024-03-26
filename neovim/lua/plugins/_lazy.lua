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
        -- colors = { onedark = { bg = "#0F111A" } },
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
          cursorline = false,
          transparency = true,
          terminal_colors = true,
          highlight_inactive_windows = true,
        },
        transparency = true,
        plugins = { treesitter = true },
      })
      onedark.load()
    end,
    enabled = true,
    cond = utils.no_vscode,
  },

  -- tree sitter
  {
    "nvim-treesitter/nvim-treesitter",
    config = function(config, opts)
      require("plugins.tree_sitter")
    end,
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile", "BufWritePre", "VeryLazy" },
    cond = utils.no_vscode,
    dependencies = {
      {
        "hiphish/rainbow-delimiters.nvim",
        event = "VeryLazy",
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
        end,
      },
    },
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
    "yamatsum/nvim-cursorline",
    config = true,
    opts = {
      cursorword = {
        enable = true,
        min_length = 1,
        hl = vim.tbl_extend(
          "force",
          vim.api.nvim_get_hl(0, { name = "MatchParen" }),
          { underline = false, bold = false }
        ),
      },
    },
  },

  -- mason
  {
    "williamboman/mason.nvim",
    cmd = { "Mason" },
    lazy = true,
    ---@type MasonSettings
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
    opts = { lsp = { auto_attach = true } },
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
    "aznhe21/actions-preview.nvim",
    keys = {
      {
        "<Leader>a",
        [[<cmd>lua require("actions-preview").code_actions()<cr>]],
        mode = { "v", "n" },
        desc = "Code Actions",
      },
    },
    lazy = true,
    opts = {
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
    },
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
      end, { desc = "Extract Function", noremap = true })
      vim.keymap.set("x", "<leader>ev", function()
        require("refactoring").refactor("Extract Variable")
      end, { desc = "Extract Variable", noremap = true })
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
    dependencies = { "nvim-neotest/nvim-nio" },
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
    "folke/todo-comments.nvim",
    config = function()
      require("todo-comments").setup()
      vim.keymap.set("n", "]t", function()
        require("todo-comments").jump_next()
      end, { desc = "Next todo comment" })

      vim.keymap.set("n", "[t", function()
        require("todo-comments").jump_prev()
      end, { desc = "Previous todo comment" })
    end,
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
    init = function()
      vim.g.use_alpha = false
    end,
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "nvim-lua/plenary.nvim", -- required by telescope
      "MunifTanjim/nui.nvim",

      -- optional
      "nvim-treesitter/nvim-treesitter",
      {
        "rcarriga/nvim-notify",
        opts = { background_colour = "#0F111A" },
        config = true,
      },
      "nvim-tree/nvim-web-devicons",
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
        -- commit = "68a2d344cea4a2e11acfb5690dc8ecd1a1ec0ce0",
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
  { "mawkler/modicator.nvim", opts = {} },
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
    opts = {
      init = function()
        require("hover.providers.lsp")
        require("hover.providers.man")
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
    },
    lazy = true,
    keys = {
      {
        "K",
        [[<cmd>lua require("hover").hover()<cr>]],
        desc = "hover.nvim",
        mode = "n",
        noremap = true,
      },
    },
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
      lastplace_open_folds = false,
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
        })
      end, { remap = false })
      vim.keymap.set("", "t", function()
        hop.hint_char1({
          direction = directions.BEFORE_CURSOR,
        })
      end, { remap = false })
      hop.setup({ uppercase = true })
    end,
    keys = { "f", "t" },
  },
  {
    "nvim-telescope/telescope.nvim",
    event = "VeryLazy",
    keys = {
      { "F", "<cmd>Telescope find_files<cr>", remap = false, mode = "n" },
      { "<Leader>b", "<cmd>Telescope buffers<cr>", remap = false, mode = "n" },
      { "<Leader>f", "<cmd>Telescope quickfix<cr>", remap = false, mode = "n" },
      { "<Leader>d", "<cmd>Telescope diagnostics<cr>", remap = false, mode = "n" },
      { "<Leader>h", "<cmd>Telescope help_tags<cr>", remap = false, mode = "n" },
      { "<C-f>", "<cmd>Telescope lsp_document_symbols<cr>", remap = false, mode = "n" },
      "R",
    },
    config = function()
      if vim.fn.executable("rg") ~= 0 then
        vim.keymap.set("n", "R", "<cmd>Telescope live_grep<cr>", {})
      end
      vim.api.nvim_create_autocmd("BufEnter", {
        pattern = "TelescopePrompt",
        callback = function()
          vim.keymap.set({ "i", "n" }, "<esc>", function()
            vim.api.nvim_win_close(0, true)
          end, { replace_keycodes = true, buffer = 0, expr = true })
        end,
      })
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
          },
        },
      })
      require("telescope").load_extension("fzf")
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    cond = utils.no_vscode,
    config = function()
      require("plugins._lualine")
    end,
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    init = function()
      vim.g.indent_blankline_filetype_exclude =
        { "startify", "help", "nerdtree", "alpha", "Outline" }
    end,
    opts = {
      exclude = {
        filetypes = { "startify", "help", "neo-tree", "alpha" },
      },
      scope = {
        enabled = false,
        show_exact_scope = false,
        show_start = false,
        show_end = false,
      },
    },
  },
  {
    "terrortylor/nvim-comment",
    cmd = { "CommentToggle" },
    main = "nvim_comment",
    init = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "arduino",
        callback = function()
          vim.bo.commentstring = "// %s"
        end,
      })
    end,
    config = true,
    opt = {
      marker_padding = true,
      comment_empty = false,
      comment_empty_trim_whitespace = true,
      create_mappings = false,
      line_mapping = nil,
      operator_mapping = nil,
      comment_chunk_text_object = "nil",
      hook = nil,
    },
    keys = { { "<Leader>c<Space>", ":CommentToggle<CR>", mode = { "n", "v" } } },
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v2.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
    },
    opts = {
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
    },
    keys = {
      {
        "<Leader>t",
        "<cmd>Neotree action=focus toggle<cr>",
        mode = "n",
        remap = true,
      },
    },
  },
  {
    "kylechui/nvim-surround",
    config = true,
    event = "VeryLazy",
  },
  {
    "declancm/cinnamon.nvim",
    opts = {},
    config = true,
    event = "VeryLazy",
  },
  {
    "nvim-focus/focus.nvim",
    opts = {},
    config = true,
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

  { "ColaMint/pokemon.nvim", event = "VeryLazy" },
  {
    "goolord/alpha-nvim",
    config = function()
      require("plugins.alpha")
    end,
    dependencies = { "ColaMint/pokemon.nvim" },
  },
  { "backdround/tabscope.nvim", config = true },

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
  {
    "folke/which-key.nvim",
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
    end,
    opts = {
      window = {
        border = "rounded",
        margin = { 1, math.floor(2 * vim.o.winwidth / 3), 1, 1 },
      },
      layout = { aligh = "left" },
    },
  },
  {
    "wintermute-cell/gitignore.nvim",
    cmd = "Gitignore",
    lazy = true,
    dependencies = { "nvim-telescope/telescope.nvim" },
  },
  {
    "f-person/git-blame.nvim",
    lazy = true,
    keys = {
      { "<Leader>gb", "<cmd>GitBlameToggle<cr>", noremap = true },
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
  { "akinsho/git-conflict.nvim", version = "*", config = true },
  { "sindrets/diffview.nvim", config = true },
  {
    "Davidyz/executable-checker.nvim",
    config = true,
    opts = { executables = { "rg", "node" } },
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
  --   enabled = false,
  -- },
}

M.config = {
  ui = {
    border = "double",
  },
}

return M
