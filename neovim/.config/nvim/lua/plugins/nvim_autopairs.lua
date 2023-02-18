local Rule = require("nvim-autopairs.rule")
local npairs = require("nvim-autopairs")

require("nvim-autopairs").setup({
  disable_filetype = { "TelescopePrompt" },
  check_ts = true,
  enable_check_bracket_line = false,
  map_cr = false,
})

_G.MUtils = {}

npairs.add_rule(Rule("'''", "'''", "python"))
npairs.add_rule(Rule('"""', '"""', "python"))

npairs.add_rule(Rule("${", "}$", "pandoc"))
npairs.add_rule(Rule("$${", "}$$", "pandoc"))
npairs.add_rule(Rule("```", "```", "pandoc"))

npairs.add_rule(Rule("${", "}$", "markdown"))
npairs.add_rule(Rule("$${", "}$$", "markdown"))
npairs.add_rule(Rule("```", "```", "markdown"))

npairs.add_rule(Rule("${", "}$", "tex"))
npairs.add_rule(Rule("$${", "}$$", "tex"))

npairs.add_rule(Rule("if then", "fi", "make"))
npairs.add_rule(Rule("for do", "done", "make"))

vim.api.nvim_set_keymap(
  "i",
  "<CR>",
  "",
  { expr = true, noremap = true, callback = MUtils.completion_confirm }
)
