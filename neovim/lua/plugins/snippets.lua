local ls = require("luasnip")
local snippet = ls.snippet
local snippet_node = ls.snippet_node
local text = ls.text_node
local insert = ls.insert_node
local func = ls.function_node
local choice = ls.choice_node
local dynamic = ls.dynamic_node
local restore = ls.restore_node
local lambda = require("luasnip.extras").lambda
local rep = require("luasnip.extras").rep
local partial = require("luasnip.extras").partial
local match = require("luasnip.extras").match
local none_empty = require("luasnip.extras").nonempty
local dynamic_lambda = require("luasnip.extras").dynamic_lambda
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local types = require("luasnip.util.types")
local conds = require("luasnip.extras.conditions")
local conds_expand = require("luasnip.extras.conditions.expand")

ls.setup({})

ls.add_snippets("markdown", {
  snippet({ trig = "cmd:new_line", dscr = "Insert a blank line." }, {
    text("<!-- cmd: new_line -->"),
    insert(0),
  }),
  snippet(
    { trig = "cmd:new_lines", dscr = "Insert blank lines." },
    fmt("<!-- cmd: new_lines: {} -->", insert(1, "num_lines"))
  ),
  snippet({ trig = "cmd:end_slide", dscr = "Insert a page break." }, {
    text("<!-- cmd: end_slide -->"),
    insert(0),
  }),
  snippet({ trig = "cmd:pause", dscr = "Insert a pause." }, {
    text("<!-- cmd: pause -->"),
    insert(0),
  }),
  snippet(
    { trig = "cmd:col_layout", dscr = "Column layout" },
    fmt("<!-- cmd: column_layout: [{}] -->", insert(1, "layout"))
  ),
  snippet(
    { trig = "cmd:col", dscr = "Start a column (0-indexed)" },
    fmt("<!-- cmd: column: {} -->", insert(1, "column_id"))
  ),
  snippet({ trig = "cmd:reset_col", dscr = "Reset column layout" }, {
    text("<!-- cmd: reset_layout -->"),
    insert(0),
  }),
  snippet(
    { dscr = "Insert Markdown table", trig = "table(%d+)x(%d+)", regTrig = true },
    {
      dynamic(1, function(args, snip)
        local nodes = {}
        local i_counter = 0
        local hlines = ""
        for _ = 1, snip.captures[2] do
          i_counter = i_counter + 1
          table.insert(nodes, text("| "))
          table.insert(nodes, insert(i_counter, "Column" .. i_counter))
          table.insert(nodes, text(" "))
          hlines = hlines .. "|:---:"
        end
        table.insert(nodes, text({ "|", "" }))
        hlines = hlines .. "|"
        table.insert(nodes, text({ hlines, "" }))
        for _ = 1, snip.captures[1] do
          for _ = 1, snip.captures[2] do
            i_counter = i_counter + 1
            table.insert(nodes, text("| "))
            table.insert(nodes, insert(i_counter))
            print(i_counter)
            table.insert(nodes, text(" "))
          end
          table.insert(nodes, text({ "|", "" }))
        end
        return snippet_node(nil, nodes)
      end),
    }
  ),
})

require("luasnip.loaders.from_vscode").lazy_load()
