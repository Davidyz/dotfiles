vim.g.coc_global_extensions = {
  'coc-jedi',
  'coc-java',
  'coc-vimlsp',
  'coc-sh',
  'coc-tsserver',
  'coc-clangd',
  'coc-snippets',
  'coc-spell-checker',
  'coc-rainbow-fart',
  'coc-marketplace',
  'coc-grammarly',
  'coc-json',
  'coc-git',
  'coc-ci',
  'coc-docker',
  'coc-lua',
  'coc-phpls'
}

vim.api.nvim_command("autocmd FileType python let b:coc_root_patterns = ['.git', '.env', 'venv', '.venv', 'setup.cfg', 'setup.py', 'pyproject.toml', 'pyrightconfig.json']")
