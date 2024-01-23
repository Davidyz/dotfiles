M = {}
local utils = require("_utils")

M.plugins = {
  -- filetypes
  {
    "shiracamus/vim-syntax-x86-objdump-d",
    cond = function()
      return vim.fn.executable("objdump") ~= 0
    end,
    event = "VeryLazy",
  },
  {
    "neovimhaskell/haskell-vim",
    ft = { "haskell", "hs" },
    config = function()
      require("plugins.haskell")
    end,
    event = "VeryLazy",
  },
  {
    "chrisbra/csv.vim",
    ft = { "csv" },
    event = "VeryLazy",
  },
  {
    "goerz/jupytext.vim",
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
    event = "VeryLazy",
  },
  {
    "vim-pandoc/vim-pandoc",
    ft = { "markdown", "pandoc", "latex" },
    config = function()
      require("plugins.pandoc")
    end,
    event = "VeryLazy",
  },
  {
    "vim-pandoc/vim-pandoc-syntax",
    ft = { "markdown", "pandoc", "latex" },
    event = "VeryLazy",
  },
  {
    "vim-scripts/cup.vim",
    ft = { "cup" },
    event = "VeryLazy",
  },
  {
    "udalov/javap-vim",
    ft = { "javap" },
    event = "VeryLazy",
  },
  {
    "cespare/vim-toml",
    branch = "main",
    ft = { "toml" },
    event = "VeryLazy",
  },
  {
    "mikelue/vim-maven-plugin",
    ft = {
      "maven",
      "xml",
    },
    event = "VeryLazy",
  },
  { "vim-scripts/crontab.vim", ft = { "crontab" }, event = "VeryLazy" },

  -- markdown
  { "mzlogin/vim-markdown-toc", event = "VeryLazy", ft = { "markdown", "pandoc" } },
  {
    "iamcco/markdown-preview.nvim",
    build = function()
      vim.fn["mkdp#util#install"]()
    end,
    ft = { "markdown", "pandoc" },
    keys = { "mp" },
    cond = utils.no_vscode,
    config = function()
      require("plugins.markdown_preview")
      require("keymaps.markdown_preview")
    end,
    event = "VeryLazy",
  },

  -- color schemes.
  {
    "olimorris/onedarkpro.nvim",
    priority = 100,
    config = function()
      local onedark = require("onedarkpro")
      onedark.setup({
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
  },
  {
    "Mofiqul/vscode.nvim",
    config = function()
      local c = require("vscode.colors").get_colors()
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
      -- require("nvim-treesitter.install").commands.TSUpdate.run()
      require("plugins.tree_sitter")
    end,
    event = "VeryLazy",
  },
  {
    "lewis6991/nvim-treesitter-context",
    config = function()
      require("plugins.treesitter-context")
    end,
    event = "VeryLazy",
  },
  { "nvim-treesitter/playground", event = "VeryLazy" },
  { "nvim-treesitter/nvim-treesitter-refactor", event = "VeryLazy" },
  {
    "windwp/nvim-autopairs",
    config = function()
      require("plugins.nvim_autopairs")
    end,
    event = "VeryLazy",
  },
  { "andymass/vim-matchup", event = "VeryLazy" },
  {
    "RRethy/vim-illuminate",
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
    config = function()
      require("mason").setup({
        ui = { border = "double" },
        max_concurrent_jobs = math.min(4, utils.cpu_count()),
      })
    end,
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

  -- lsp
  {
    "neovim/nvim-lspconfig",
    config = function()
      require("mason").setup()
      require("plugins._lsp")
      require("keymaps._lsp")
    end,
    dependencies = { "folke/neodev.nvim" },
  },
  { "hrsh7th/nvim-cmp", event = "LspAttach" },
  { "hrsh7th/cmp-nvim-lsp", event = "LspAttach" },
  { "hrsh7th/cmp-buffer", event = "LspAttach" },
  { "hrsh7th/cmp-path", event = "LspAttach" },
  { "hrsh7th/cmp-cmdline", event = "LspAttach" },
  { "hrsh7th/cmp-nvim-lua", event = "LspAttach" },
  { "L3MON4D3/LuaSnip", event = "LspAttach" },
  { "saadparwaiz1/cmp_luasnip", event = "LspAttach" },
  { "rafamadriz/friendly-snippets", event = "LspAttach" },
  {
    "williamboman/mason-lspconfig.nvim",
    event = "VeryLazy",
    dependencies = { "folke/neodev.nvim" },
  },
  { "hrsh7th/cmp-nvim-lsp-signature-help", event = "LspAttach" },
  {
    "SmiteshP/nvim-navic",
    config = function()
      require("nvim-navic").setup()
    end,
    event = "LspAttach",
  },
  {
    "uga-rosa/cmp-dictionary",
    cond = function()
      return vim.fn.filereadable("~/.local/lib/aspell/en.dict") ~= 0
    end,
    config = function()
      require("cmd_dictionary").setup({
        dic = {
          ["*"] = "~/.local/lib/aspell/en.dict",
        },
      })
    end,
    event = "LspAttach",
  },
  {
    "tamago324/cmp-zsh",
    event = "LspAttach",
    config = function()
      if vim.fn.executable("zsh") then
        io.popen('zsh -c "zmodload zsh/zpty"')
      end
      require("cmp_zsh").setup({ zshrc = true, filetypes = { "zsh" } })
    end,
  },
  {
    "j-hui/fidget.nvim",
    tag = "legacy",
    event = "LspAttach",
    config = function()
      vim.api.nvim_set_hl(0, "FidgetTitle", { link = "Exception" })
      vim.api.nvim_set_hl(0, "FidgetTask", { link = "Tag" })
      require("fidget").setup({
        window = { blend = 0, border = "rounded" },
        align = { bottom = false },
        fmt = { stack_upwards = false },
      })
    end,
  },
  {
    "Davidyz/lsp-location-handler.nvim",
    config = function()
      require("location-handler").setup()
    end,
    event = "LspAttach",
  },
  { "folke/neodev.nvim", event = "LspAttach", config = true },
  {
    "aznhe21/actions-preview.nvim",
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
  },
  {
    "ThePrimeagen/refactoring.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
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
  },
  {
    "zbirenbaum/copilot.lua",
    event = "LspAttach",
    config = function()
      require("copilot").setup({
        suggestion = { enabled = false },
        panel = { enabled = false },
      })
    end,
  },
  {
    "zbirenbaum/copilot-cmp",
    config = function()
      require("copilot_cmp").setup()
    end,
  },
  {
    "onsails/lspkind.nvim",
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
    config = function()
      require("plugins._ufo")
    end,
    event = "LspAttach",
  },

  -- dap
  {
    "mfussenegger/nvim-dap",
    cond = utils.no_vscode,
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
  },
  { "rcarriga/nvim-dap-ui", cond = utils.no_vscode, event = "VeryLazy" },
  {
    "jbyuki/one-small-step-for-vimkind",
    cond = utils.no_vscode,
    event = "VeryLazy",
  },
  {
    "mfussenegger/nvim-jdtls",
    ft = { "java" },
    cond = utils.no_vscode,
    event = "VeryLazy",
  },
  { "jay-babu/mason-nvim-dap.nvim", cond = utils.no_vscode, event = "VeryLazy" },

  -- vimspector
  -- "puremourning/vimspector",

  -- misc
  -- "~/git/fauxpilot.nvim",
  -- "github/copilot.vim",
  --{ "altermo/nxwm" },
  {
    "gorbit99/codewindow.nvim",
    config = function()
      local codewindow = require("codewindow")
      codewindow.setup({ window_border = "double" })
      codewindow.apply_default_keybinds()
    end,
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
          -- require('hover.providers.man')
          require("hover.providers.dictionary")
        end,
        preview_opts = {
          border = "double",
        },
        -- Whether the contents of a currently open hover window should be moved
        -- to a :h preview-window when pressing the hover keymap.
        preview_window = false,
        title = true,
      })

      -- Setup keymaps
      vim.keymap.set("n", "K", require("hover").hover, { desc = "hover.nvim" })
      --vim.keymap.set(
      --"n",
      --"gK",
      --require("hover").hover_select,
      --{ desc = "hover.nvim (select)" }
      --)
    end,
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
    config = function()
      require("nvim-lastplace").setup({
        lastplace_ignore_buftype = { "quickfix", "nofile", "help" },
        lastplace_ignore_filetype = { "gitcommit", "gitrebase", "svn", "hgcommit" },
        lastplace_open_folds = true,
      })
    end,
    event = "VeryLazy",
  },
  {
    "lewis6991/gitsigns.nvim",
    branch = "release",
    config = function()
      require("gitsigns").setup({
        signs = {
          add = { text = "+" },
          change = { text = "~" },
          delete = { text = "_" },
          topdelete = { text = "‾" },
          changedelete = { text = ">" },
          untracked = { text = "┆" },
        },
      })
    end,
    event = "VeryLazy",
  },
  { "nvim-lua/plenary.nvim", event = "VeryLazy" },
  {
    "smoka7/hop.nvim",
    config = function()
      local hop = require("hop")
      local directions = require("hop.hint").HintDirection
      vim.keymap.set("", "f", function()
        hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true })
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
  },
  {
    "nvim-telescope/telescope.nvim",
    event = "VeryLazy",
    config = function()
      require("keymaps.telescope")
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    cond = utils.no_vscode,
    config = function()
      require("plugins._lualine")
    end,
  },
  { "kyazdani42/nvim-web-devicons", event = "VeryLazy" },
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
    "preservim/nerdcommenter",
    event = "VeryLazy",
    keys = { "<Leader>c<space>" },
    config = function()
      require("keymaps.NERDCommenter")
    end,
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v2.x",
    keys = { "<Leader>t" },
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
          neotree.show("", true)
        end,
      })
    end,
  },
  {
    "kylechui/nvim-surround",
    config = function()
      require("nvim-surround").setup()
    end,
    event = "VeryLazy",
  },
  { "psliwka/vim-smoothie", event = "VeryLazy" },
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
    event = "VeryLazy",
    config = function()
      require("md-code")
    end,
  },
  {
    "dstein64/vim-startuptime",
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
    config = function()
      require("toggleterm").setup({
        open_mapping = "<C-\\>",
        direction = "float",
        float_opts = {
          border = "curved",
        },
      })
    end,
  },
  {
    "jim-fx/sudoku.nvim",
    cmd = "Sudoku",
    config = function()
      require("sudoku").setup({
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
      })
    end,
    event = "VeryLazy",
  },
  {
    "folke/which-key.nvim",
    config = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
      require("which-key").setup({
        window = {
          border = "rounded",
          margin = { 1, math.floor(2 * vim.o.winwidth / 3), 1, 1 },
        },
        layout = { aligh = "left" },
      })
    end,
  },
  {
    "wintermute-cell/gitignore.nvim",
    cmd = "Gitignore",
    dependencies = { "nvim-telescope/telescope.nvim" },
  },
  {
    "f-person/git-blame.nvim",
    keys = { "<Leader>gb", "<Leader>go", "<Leader>gc" },
    config = function()
      local gb = require("gitblame")
      vim.g.gitblame_enabled = 0
      vim.keymap.set("n", "<Leader>gb", vim.fn["GitBlameToggle"], { noremap = true })
      vim.keymap.set("n", "<Leader>go", function()
        vim.fn["GitBlameOpenCommitURL"]()
        vim.fn["GitBlameDisable"]()
      end, { noremap = true })
      vim.keymap.set("n", "<Leader>gc", function()
        vim.fn["GitBlameCopyCommitURL"]()
        vim.fn["GitBlameDisable"]()
      end, { noremap = true })
    end,
  },
  {
    "Davidyz/executable-checker.nvim",
    config = function()
      require("executable-checker").setup({ executables = { "rg", "node" } })
    end,
  },
  {
    "3rd/image.nvim",
    filetypes = { "markdown" },
    build = "luarocks --local --lua-version 5.1 install magick",
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
  },
}

M.config = {
  ui = {
    border = "double",
  },
}

return M
