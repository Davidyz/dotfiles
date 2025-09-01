local fonts = {
  "Maple\\ Mono\\ Normal\\ NL\\ NF\\ CN",
  "Cascadia\\ Mono",
  "Symbols\\ Nerd\\ Font\\ Mono",
  "codicon",
  "Noto\\ Sans\\ Mono",
  "Noto\\ Sans\\ Mono\\ CJK\\ SC",
}

vim.opt.guifont = string.format([[%s:h11.5]], table.concat(fonts, ","))
