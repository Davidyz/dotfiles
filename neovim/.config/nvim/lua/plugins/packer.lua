local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
local packer_bootstrap = false
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end

return require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'
  use 'windwp/nvim-autopairs'
  use 'easymotion/vim-easymotion'
  use {
    'neovimhaskell/haskell-vim',
    ft = {'haskell', 'hs'}
  }
  use {
    'vim-pandoc/vim-pandoc',
    ft = {'markdown', 'pandoc', 'latex'}
  }
  use {
    'vim-pandoc/vim-pandoc-syntax',
    ft = {'markdown', 'pandoc', 'latex'}
  }
  use {
    'junegunn/fzf',
    run = ":call fzf#install()"
  }
  use 'junegunn/fzf.vim'
  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'kyazdani42/nvim-web-devicons', opt = true }
  }
  use 'itchyny/vim-gitbranch'
  use 'vim-scripts/cup.vim'
  use 'Yggdroot/indentLine'
  use 'luochen1990/rainbow'
  use 'preservim/nerdcommenter'
  use 'preservim/nerdtree'
  use 'goerz/jupytext.vim'
  use {
    'udalov/javap-vim',
    ft = {'javap'}
  }
  use 'tpope/vim-surround'
  use 'psliwka/vim-smoothie'
  use {
    'cespare/vim-toml',
    branch = 'main'
   }
  use 'mhinz/vim-startify'
  use 'ervandew/supertab'
  use 'mikelue/vim-maven-plugin'
  use 'chaoren/vim-wordmotion'
  use {
    'lark-parser/vim-lark-syntax',
    ft = {'lark'}
   }
  use 'ryanoasis/vim-devicons'
  use {
    'nvie/vim-flake8',
    ft = {'python'}
  }
  use {
    'psf/black',
    ft = {'python'}
  }
  use 'vim-scripts/crontab.vim'
  use 'ayu-theme/ayu-vim'
  use 'joshdick/onedark.vim'
  use {
    'kaicataldo/material.vim',
    branch= 'main'
  }
  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate'
  }
  use {
    'neoclide/coc.nvim',
    branch = 'release'
  }
  use 'rafcamlet/coc-nvim-lua'
  use 'IngoMeyer441/coc_current_word'
  use 'github/copilot.vim'
  use {
    'iamcco/markdown-preview.nvim',
    run = 'cd app && yarn install',
    ft = {'markdown', 'pandoc'}
  }

  if packer_bootstrap then
    require('packer').sync()
  end
end)
