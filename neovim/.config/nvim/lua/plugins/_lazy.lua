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
  { "https://gitlab.com/HiPhish/nvim-ts-rainbow2.git", event = "VeryLazy" },

  -- mason
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup({
        ui = { border = "double" },
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
    "jose-elias-alvarez/null-ls.nvim",
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
  { "williamboman/mason-lspconfig.nvim", event = "VeryLazy" },
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
  { "easymotion/vim-easymotion", event = "VeryLazy" },
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
    "lukas-reineke/indent-blankline.nvim",
    config = function()
      vim.g.indent_blankline_filetype_exclude = { "startify", "help", "nerdtree" }
      require("indent_blankline").setup({
        -- for example, context is off by default, use this to turn it on
        show_current_context = true,
        show_current_context_start = false,
        show_end_of_line = false,
      })
    end,
    event = "VeryLazy",
  },
  {
    "preservim/nerdcommenter",
    event = "VeryLazy",
    config = function()
      require("keymaps.NERDCommenter")
    end,
  },
  {
    "preservim/nerdtree",
    cond = utils.no_vscode,
    config = function()
      require("plugins.NERDTree")
      require("keymaps.NERDTree")
    end,
    event = "VeryLazy",
  },
  { "Xuyuanp/nerdtree-git-plugin", event = "VeryLazy" },
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
    "Davidyz/make.nvim",
    branch = "main",
    event = "VeryLazy",
  },
  {
    "Davidyz/md-code.nvim",
    ft = { "markdown" },
    cond = utils.no_vscode,
    event = "VeryLazy",
  },
  {
    "dstein64/vim-startuptime",
  },
  {
    "mhinz/vim-startify",
    cond = utils.no_vscode,
    config = function()
      if vim.fn.has("StartupTime") then
        vim.api.nvim_command("StartupTime --save startup_time --hidden")
      end
      require("plugins.utils").make_pokemon()
      require("plugins.startify")
    end,
    dependencies = {
      "ColaMint/pokemon.nvim",
      "dstein64/vim-startuptime",
    },
  },
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
}

M.config = {
  ui = {
    border = "double",
  },
}

return M
