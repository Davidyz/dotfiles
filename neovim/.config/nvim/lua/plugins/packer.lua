local fn = vim.fn
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
local packer_bootstrap = false
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({
    "git",
    "clone",
    "--depth",
    "1",
    "https://github.com/wbthomason/packer.nvim",
    install_path,
  })
end

return require("packer").startup(function(use)
  use("wbthomason/packer.nvim")

  -- filetypes
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
    "nvie/vim-flake8",
    ft = { "python" },
  })
  use({
    "psf/black",
    ft = { "python" },
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
    "iamcco/markdown-preview.nvim",
    run = "cd app && yarn install",
    ft = { "markdown", "pandoc" },
  })

  -- color schemes.
  use("ayu-theme/ayu-vim")
  use("projekt0n/github-nvim-theme")
  use("cocopon/iceberg.vim")
  use({
    "navarasu/onedark.nvim",
  })
  use({
    "kaicataldo/material.vim",
    branch = "main",
  })
  use("Th3Whit3Wolf/one-nvim")
  use("Cybolic/palenight.vim")

  -- tree sitter
  use({
    "nvim-treesitter/nvim-treesitter",
    run = ":TSUpdate",
  })
  use("romgrk/nvim-treesitter-context")
  use("nvim-treesitter/playground")
  use("windwp/nvim-autopairs")
  use("andymass/vim-matchup")
  use("SmiteshP/nvim-gps")
  use("p00f/nvim-ts-rainbow")

  -- coc.nvim
  use({
    "neoclide/coc.nvim",
    branch = "release",
  })
  use({
    "rafcamlet/coc-nvim-lua",
    ft = { "lua" },
  })

  -- misc
  -- use 'github/copilot.vim'
  use({
    "lilydjwg/fcitx.vim",
    cond = function()
      return vim.fn.executable("fcitx5") or vim.fn.executable("fcitx")
    end,
  })
  use("easymotion/vim-easymotion")
  use({
    "junegunn/fzf",
    run = ":call fzf#install()",
  })
  use("junegunn/fzf.vim")
  use({
    "nvim-lualine/lualine.nvim",
    requires = { "kyazdani42/nvim-web-devicons", opt = true },
  })
  use("itchyny/vim-gitbranch")
  use("Yggdroot/indentLine")
  use("preservim/nerdcommenter")
  use("preservim/nerdtree")
  use("Xuyuanp/nerdtree-git-plugin")
  use("tpope/vim-surround")
  use("psliwka/vim-smoothie")
  use("chaoren/vim-wordmotion")
  use("ryanoasis/vim-devicons")
  use("vim-scripts/restore_view.vim")
  use("zhaocai/GoldenView.Vim")
  use({
    "Davidyz/make.nvim",
    branch = "main",
  })
  use("~/git/md-code.nvim")
  use("mhinz/vim-startify")
  use({
    "folke/which-key.nvim",
    config = function()
      require("which-key").setup({
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
      })
    end,
  })

  if packer_bootstrap then
    require("packer").sync()
  end
end)
