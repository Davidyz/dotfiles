require("keymaps.utils")
require("utils")

local function show_doc()
  if
    List_contains({ "vim", "help" }, vim.bo.filetype)
    or string.match(vim.fn.getline("."), "vim%." .. "%w+%." .. vim.fn.expand("<cword>") .. "%(")
  then
    vim.api.nvim_exec("h " .. vim.fn.expand("<cword>"), {})
  elseif vim.fn["coc#rpc#ready"] then
    vim.fn["CocActionAsync"]("doHover")
  else
    vim.api.nvim_exec("!" .. vim.api.nvim_get_option("keywordprg") .. " " .. vim.fn.expand("<cword>"), {})
  end
end

local function check_back_space()
  local col = vim.fn.col(".") - 1
  return (col > 1) or string.match(vim.fn.getline(".")[col - 1], ".%s+")
end

Set_keymap("n", "K", "", { silent = true, noremap = true, callback = show_doc })
Set_keymap("x", "<leader>a", "<Plug>(coc-codeaction-selected)", false)
Set_keymap("n", "<leader>a", "<Plug>(coc-codeaction-selected)", false)
Set_keymap("n", "<leader>r", "<Plug>(coc-rename)", false)
Set_keymap("n", "<leader>f", "<Plug>(coc-fix-current)", false)

Set_keymap("i", "<cr>", [[pumvisible() ? coc#_select_confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"]], {
  silent = true,
  expr = true,
  noremap = true,
})
Set_keymap("i", "<C-space>", "", { silent = true, expr = true, noremap = true, callback = vim.fn["coc#refresh"] })
Set_keymap("i", "<TAB>", "", {
  silent = true,
  expr = true,
  noremap = true,
  callback = function()
    if vim.fn.pumvisible() then
      return GetTermCode([[<C-n>]])
    elseif check_back_space() then
      return GetTermCode([[<TAB>]])
    else
      return vim.fn["coc#refresh"]()
    end
  end,
})

Set_keymap("i", "<S-TAB>", "", {
  silent = true,
  expr = true,
  callback = function()
    if vim.fn.pumvisible() then
      return GetTermCode([[<C-p>]])
    else
      return GetTermCode([[<C-h>]])
    end
  end,
})
Set_keymap("n", "gd", "<Plug>(coc-definition)", { silent = true })
Set_keymap("n", "gr", "<Plug>(coc-references)", { silent = true })
