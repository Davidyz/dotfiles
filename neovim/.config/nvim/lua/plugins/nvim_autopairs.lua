local Rule = require('nvim-autopairs.rule')
local npairs = require('nvim-autopairs')

require('nvim-autopairs').setup({
  disable_filetype = { "TelescopePrompt" },
  check_ts = true,
  enable_check_bracket_line = false,
  map_cr = false
})

-- npairs.add_rule({Rule("${", "}$", 'pandoc'),
                 -- Rule("$${", "}$$", 'pandoc')})

_G.MUtils= {}

MUtils.completion_confirm=function()
  if vim.fn.pumvisible() ~= 0  then
    return vim.fn["coc#_select_confirm"]()
  else
    return npairs.autopairs_cr()
  end
end

vim.api.nvim_set_keymap('i' , '<CR>','v:lua.MUtils.completion_confirm()', {expr = true , noremap = true})