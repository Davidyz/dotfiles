local Rule = require("nvim-autopairs.rule")
local npairs = require("nvim-autopairs")

require("nvim-autopairs").setup({
  disable_filetype = {},
  check_ts = true,
  enable_check_bracket_line = false,
  map_cr = false,
  map_bs = true,
})

npairs.add_rule(Rule("'''", "'''", "python"))
npairs.add_rule(Rule('"""', '"""', "python"))

npairs.add_rule(Rule("${", "}$", "pandoc"))
npairs.add_rule(Rule("$${", "}$$", "pandoc"))
npairs.add_rule(Rule("```", "```", "pandoc"))

npairs.add_rule(Rule("${", "}$", "markdown"))
npairs.add_rule(Rule("$${", "}$$", "markdown"))
npairs.add_rule(Rule("```", "```", "markdown"))
npairs.add_rule(Rule("<!--", "-->", "markdown"))

npairs.add_rule(Rule("${", "}$", "tex"))
npairs.add_rule(Rule("$${", "}$$", "tex"))

npairs.add_rule(Rule("if then", "fi", "make"))
npairs.add_rule(Rule("for do", "done", "make"))
