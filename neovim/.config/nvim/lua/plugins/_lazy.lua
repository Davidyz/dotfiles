M = {}
require("_utils")

local function no_vscode()
  return vim.fn.exists("g:vscode") == 0
end

M.plugins = {

  -- filetypes
  {
    "shiracamus/vim-syntax-x86-objdump-d",
    cond = function()
      return vim.fn.executable("objdump") ~= 0
    end,
  },
  {
    "neovimhaskell/haskell-vim",
    ft = { "haskell", "hs" },
  },
  {
    "chrisbra/csv.vim",
    ft = { "csv" },
  },
  {
    "goerz/jupytext.vim",
    ft = { "jupyter", "notebook", "ipynb", "py", "json" },
  },
  {
    "lark-parser/vim-lark-syntax",
    ft = { "lark" },
  },
  {
    "vim-pandoc/vim-pandoc",
    ft = { "markdown", "pandoc", "latex" },
  },
  {
    "vim-pandoc/vim-pandoc-syntax",
    ft = { "markdown", "pandoc", "latex" },
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
    "mikelue/vim-maven-plugin",
    ft = {
      "maven",
      "xml",
    },
  },
  "vim-scripts/crontab.vim",

  -- markdown
  { "mzlogin/vim-markdown-toc", ft = { "markdown", "pandoc" } },
  {
    "iamcco/markdown-preview.nvim",
    build = function()
      vim.fn["mkdp#util#install"]()
    end,
  },

  -- color schemes.
  {
    "olimorris/onedarkpro.nvim",
  },

  -- tree sitter
  {
    "nvim-treesitter/nvim-treesitter",
    config = function(config, opts)
      vim.api.nvim_command("TSUpdate")
    end,
  },
  "lewis6991/nvim-treesitter-context",
  "nvim-treesitter/playground",
  "nvim-treesitter/nvim-treesitter-refactor",
  "windwp/nvim-autopairs",
  "andymass/vim-matchup",
  "https://gitlab.com/HiPhish/nvim-ts-rainbow2.git",

  -- mason
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end,
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    config = function()
      require("plugins.mason_tools")
    end,
  },
  {
    "jose-elias-alvarez/null-ls.nvim",
    config = require("plugins.null_ls"),
  },

  -- lsp
  { "neovim/nvim-lspconfig" },
  { "hrsh7th/nvim-cmp" },
  { "hrsh7th/cmp-nvim-lsp" },
  { "hrsh7th/cmp-buffer" },
  { "hrsh7th/cmp-path" },
  { "hrsh7th/cmp-cmdline" },
  { "hrsh7th/cmp-nvim-lua" },
  { "L3MON4D3/LuaSnip" },
  { "saadparwaiz1/cmp_luasnip" },
  { "rafamadriz/friendly-snippets" },
  { "williamboman/mason-lspconfig.nvim" },
  { "hrsh7th/cmp-nvim-lsp-signature-help" },
  {
    "SmiteshP/nvim-navic",
    config = function()
      require("nvim-navic").setup()
    end,
  },

  -- dap
  "mfussenegger/nvim-dap",
  "theHamsta/nvim-dap-virtual-text",
  "rcarriga/nvim-dap-ui",
  "jbyuki/one-small-step-for-vimkind",
  "mfussenegger/nvim-jdtls",

  -- vimspector
  -- "puremourning/vimspector",

  -- misc
  -- "~/git/fauxpilot.nvim",
  -- "github/copilot.vim",
  {
    "ethanholz/nvim-lastplace",
    config = function()
      require("nvim-lastplace").setup({})
    end,
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
  },
  "nvim-lua/plenary.nvim",
  "easymotion/vim-easymotion",
  "nvim-telescope/telescope.nvim",
  {
    "nvim-lualine/lualine.nvim",
  },
  { "kyazdani42/nvim-web-devicons" },
  "itchyny/vim-gitbranch",
  { "Yggdroot/indentLine", ft = SOURCE_CODE },
  {
    "preservim/nerdcommenter",
  },
  "preservim/nerdtree",
  "Xuyuanp/nerdtree-git-plugin",
  "tpope/vim-surround",
  "psliwka/vim-smoothie",
  "chaoren/vim-wordmotion",
  "ryanoasis/vim-devicons",
  "vim-scripts/restore_view.vim",
  { "zhaocai/GoldenView.Vim", cond = no_vscode },
  {
    "Davidyz/make.nvim",
    branch = "main",
  },
  { "Davidyz/md-code.nvim", ft = { "markdown" }, cond = no_vscode },
  {
    "mhinz/vim-startify",
    cond = no_vscode,
  },
  {
    "gpanders/editorconfig.nvim",
    cond = function()
      return vim.version().major < 1 and vim.version().minor < 9
    end,
  },
}

M.config = { ui = {
  border = "double",
} }
return M
