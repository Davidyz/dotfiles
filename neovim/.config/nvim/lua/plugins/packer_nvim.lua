local function no_vscode()
  return vim.fn.exists("g:vscode") == 0
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
    "olimorris/onedarkpro.nvim",
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
  use("lewis6991/nvim-treesitter-context")
  use("nvim-treesitter/playground")
  use("windwp/nvim-autopairs")
  use("andymass/vim-matchup")
  use("p00f/nvim-ts-rainbow")

  -- mason
  use({
    "williamboman/mason.nvim",
    config = function()
      require('mason').setup()
    end,
    cond = no_vscode,
  })
  use({
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    config = function()
      require("mason-tool-installer").setup({
        auto_update = true,
        ensure_installed = {
          "black",
          "flake8",
          "clang-format",
          "shellcheck",
          "stylua",
          "clangd",
          "lua-language-server",
          "vim-language-server",
          "pyright",
          "clangd",
          "beautysh",
          "mypy",
          'jdtls'
        },
      })
    end,
    cond = no_vscode,
  })
  use({
    "jose-elias-alvarez/null-ls.nvim",
    config = function()
      local null_ls = require("null-ls")
      local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

      null_ls.setup({
        sources = {
          null_ls.builtins.formatting.stylua.with({
            extra_args = { "--indent-type", "Spaces", "--indent-width", "2" },
          }),
          null_ls.builtins.formatting.black,
          null_ls.builtins.formatting.clang_format,
          null_ls.builtins.formatting.beautysh,
          null_ls.builtins.diagnostics.flake8.with({
            extra_args = { "--max-line-length=88" },
          }),
          null_ls.builtins.diagnostics.mypy,
          null_ls.builtins.diagnostics.clang_check,
        },
        -- you can reuse a shared lspconfig on_attach callback here
        on_attach = function(client, bufnr)
          if client.supports_method("textDocument/formatting") then
            vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
            vim.api.nvim_create_autocmd("BufWritePre", {
              group = augroup,
              buffer = bufnr,
              callback = function()
                -- on 0.8, you should use vim.lsp.buf.format({ bufnr = bufnr }) instead
                vim.lsp.buf.formatting_sync()
              end,
            })
          end
        end,
      })
    end,
    cond = no_vscode,
    config = function()
  local null_ls = require("null-ls")
  local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
  null_ls.setup({
    sources = {
      null_ls.builtins.formatting.stylua.with({
        extra_args = { "--indent-type", "Spaces", "--indent-width", "2" },
      }),
      null_ls.builtins.formatting.black,
      null_ls.builtins.formatting.clang_format,
      null_ls.builtins.formatting.beautysh,
      null_ls.builtins.diagnostics.flake8,
      null_ls.builtins.diagnostics.mypy,
      null_ls.builtins.diagnostics.clang_check,
    },
    -- you can reuse a shared lspconfig on_attach callback here
    on_attach = function(client, bufnr)
      if client.supports_method("textDocument/formatting") then
        vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
        vim.api.nvim_create_autocmd("BufWritePre", {
          group = augroup,
          buffer = bufnr,
          callback = function()
            -- on 0.8, you should use vim.lsp.buf.format({ bufnr = bufnr }) instead
            vim.lsp.buf.formatting_sync()
          end,
        })
      end
    end,
  })

    end
  })

  -- lsp
  use({ "neovim/nvim-lspconfig" })
  use({ 'hrsh7th/nvim-cmp' })
  use({ 'hrsh7th/cmp-nvim-lsp' })
  use({ 'saadparwaiz1/cmp_luasnip' }) -- Snippets source for nvim-cmp
  use({ 'L3MON4D3/LuaSnip' })
  -- use ({"SmiteshP/nvim-navic"})

  -- coc.nvim
  -- use({
  -- "neoclide/coc.nvim",
  -- branch = "release",
  -- cond = no_vscode,
  -- })
  -- use({
  -- "rafcamlet/coc-nvim-lua",
  -- ft = { "lua" },
  -- cond = function()
  -- return vim.b.editting_vim_config and no_vscode()
  -- end,
  -- })

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
  use("nvim-lua/plenary.nvim")
  use("easymotion/vim-easymotion")
  use({ "vijaymarupudi/nvim-fzf" })
  use({
    "nvim-lualine/lualine.nvim",
    requires = { "kyazdani42/nvim-web-devicons", opt = false },
  })
  use("itchyny/vim-gitbranch")
  use({ "Yggdroot/indentLine", ft = SOURCE_CODE, cond = no_vscode })
  use("preservim/nerdcommenter")
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

  if vim.g.packer_bootstrap then
    require("packer").sync()
  end
end)
