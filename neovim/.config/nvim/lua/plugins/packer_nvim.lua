local function no_vscode()
  return vim.fn.exists("g:vscode") == 0
end

return require("packer").startup(function(use)
  use("wbthomason/packer.nvim")

  -- filetypes
  use({
    "shiracamus/vim-syntax-x86-objdump-d",
    cond = function()
      return vim.fn.executable("objdump")
    end,
  })
  use({
    "neovimhaskell/haskell-vim",
    ft = { "haskell", "hs" },
  })
  use({
    "chrisbra/csv.vim",
    ft = { "csv" },
  })
  use({
    "goerz/jupytext.vim",
    ft = { "jupyter", "notebook", "ipynb", "py", "json" },
  })
  use({
    "lark-parser/vim-lark-syntax",
    ft = { "lark" },
  })
  use({
    "vim-pandoc/vim-pandoc",
    ft = { "markdown", "pandoc", "latex" },
  })
  use({
    "vim-pandoc/vim-pandoc-syntax",
    ft = { "markdown", "pandoc", "latex" },
  })
  use({
    "vim-scripts/cup.vim",
    ft = { "cup" },
  })
  use({
    "udalov/javap-vim",
    ft = { "javap" },
  })
  use({
    "cespare/vim-toml",
    branch = "main",
    ft = { "toml" },
  })
  use({
    "mikelue/vim-maven-plugin",
    ft = {
      "maven",
      "xml",
    },
  })
  use("vim-scripts/crontab.vim")

  -- markdown
  use({ "mzlogin/vim-markdown-toc", ft = { "markdown", "pandoc" } })
  use({
    "davidgranstrom/nvim-markdown-preview",
    config = function()
      vim.g.nvim_markdown_preview_theme = "github"
    end,
    ft = { "markdown", "pandoc" },
  })

  -- color schemes.
  use({
    "olimorris/onedarkpro.nvim",
  })

  -- tree sitter
  use({
    "nvim-treesitter/nvim-treesitter",
    run = ":TSUpdate",
  })
  use("lewis6991/nvim-treesitter-context")
  use("nvim-treesitter/playground")
  use("windwp/nvim-autopairs")
  use("andymass/vim-matchup")
  use("https://gitlab.com/HiPhish/nvim-ts-rainbow2.git")

  -- mason
  use({
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end,
  })
  use({
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    config = function()
      require("plugins.mason_tools")
    end,
  })
  use({
    "jose-elias-alvarez/null-ls.nvim",
    config = require("plugins.null_ls"),
  })

  -- lsp
  use({ "neovim/nvim-lspconfig" })
  use({ "hrsh7th/nvim-cmp" })
  use({ "hrsh7th/cmp-nvim-lsp" })
  use({ "hrsh7th/cmp-buffer" })
  use({ "hrsh7th/cmp-path" })
  use({ "hrsh7th/cmp-cmdline" })
  use({ "hrsh7th/cmp-nvim-lua" })
  use({ "L3MON4D3/LuaSnip" })
  use({ "saadparwaiz1/cmp_luasnip" })
  use({ "rafamadriz/friendly-snippets" })
  use({ "williamboman/mason-lspconfig.nvim" })
  use({ "hrsh7th/cmp-nvim-lsp-signature-help" })
  use({
    "RRethy/vim-illuminate",
    config = function()
      local highlight = vim.api.nvim_get_hl_by_name("TermCursorNC", {})
      highlight.underline = false
      vim.api.nvim_set_hl(0, "IlluminatedWordText", highlight)
      vim.api.nvim_set_hl(0, "IlluminatedWordRead", highlight)
      vim.api.nvim_set_hl(0, "IlluminatedWordWrite", highlight)
    end,
  })
  use({
    "SmiteshP/nvim-navic",
    config = function()
      require("nvim-navic").setup()
    end,
  })

  -- dap
  use("mfussenegger/nvim-dap")
  use("theHamsta/nvim-dap-virtual-text")
  use("rcarriga/nvim-dap-ui")
  use("jbyuki/one-small-step-for-vimkind")
  use("mfussenegger/nvim-jdtls")

  -- vimspector
  -- use("puremourning/vimspector")

  -- misc
  -- use("~/git/fauxpilot.nvim")
  -- use("github/copilot.vim")
  use({
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
  })
  use("nvim-lua/plenary.nvim")
  use("easymotion/vim-easymotion")
  use("nvim-telescope/telescope.nvim")
  use({
    "nvim-lualine/lualine.nvim",
    requires = { "kyazdani42/nvim-web-devicons", opt = false },
  })
  use("itchyny/vim-gitbranch")
  use({ "Yggdroot/indentLine", ft = SOURCE_CODE, cond = no_vscode })
  use({
    "preservim/nerdcommenter",
    config = function()
      vim.g.NERDCustomDelimiters = { ipynb = { left = "#", leftAlt = "#" } }
    end,
  })
  use("preservim/nerdtree")
  use("Xuyuanp/nerdtree-git-plugin")
  use("tpope/vim-surround")
  use("psliwka/vim-smoothie")
  use("chaoren/vim-wordmotion")
  use("ryanoasis/vim-devicons")
  use("vim-scripts/restore_view.vim")
  use({ "zhaocai/GoldenView.Vim", cond = no_vscode })
  use({
    "Davidyz/make.nvim",
    branch = "main",
  })
  use({ "Davidyz/md-code.nvim", ft = { "markdown" }, cond = no_vscode })
  use({
    "mhinz/vim-startify",
    cond = no_vscode,
  })
  use({
    "gpanders/editorconfig.nvim",
    cond = function()
      return vim.version().major < 1 and vim.version().minor < 9
    end,
  })

  if vim.g.packer_bootstrap then
    require("packer").sync()
  end
end)
