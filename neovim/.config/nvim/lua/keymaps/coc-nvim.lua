local km_utils = require("keymaps.utils")
local utils = require("utils")

local function show_doc()
  if
    utils.contains({ "vim", "help" }, vim.bo.filetype)
    or string.match(vim.fn.getline("."), "vim%." .. "%w+%." .. vim.fn.expand("<cword>") .. "%(")
  then
    local status, result = pcall(vim.api.nvim_exec, "h " .. vim.fn.expand("<cword>"), false)
    if status then
      return
    end
  end
  if vim.fn["coc#rpc#ready"] then
    vim.fn["CocActionAsync"]("doHover")
  else
    vim.api.nvim_exec("!" .. vim.api.nvim_get_option("keywordprg") .. " " .. vim.fn.expand("<cword>"), {})
  end
end

function _G.check_back_space()
  local col = vim.fn.col(".") - 1
  local line = vim.fn.getline(".")[col - 1] or ""
  return (col > 1) or string.match(line, "%s") == nil
end

km_utils.setKeymap("n", "K", show_doc, { silent = true, noremap = true })
km_utils.setKeymap("x", "<leader>a", "<Plug>(coc-codeaction-selected)", false)
km_utils.setKeymap("n", "<leader>a", "<Plug>(coc-codeaction-selected)", false)
km_utils.setKeymap("n", "<leader>r", "<Plug>(coc-rename)", false)
km_utils.setKeymap("n", "<leader>f", "<Plug>(coc-fix-current)", false)

-- km_utils.setKeymap("i", "<cr>", [[pumvisible() ? coc#_select_confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"]], {
km_utils.setKeymap("i", "<cr>", function()
  if vim.fn["coc#pum#visible"]() ~= 0 then
    return vim.fn["coc#_select_confirm"]()
  else
    vim.fn["coc#on_enter"]()
    return utils.getTermCode("<CR>")
  end
end, {
  silent = true,
  expr = true,
  noremap = true,
})
km_utils.setKeymap("i", "<C-space>", vim.fn["coc#refresh"], { silent = true, expr = true, noremap = true })

-- km_utils.setKeymap("i", "<TAB>", [[pumvisible() ? "\<C-n>" : "\<TAB>"]], {
km_utils.setKeymap("i", "<TAB>", function()
  if vim.fn["coc#pum#visible"]() ~= 0 then
    return vim.fn["coc#pum#next"](1)
  elseif check_back_space() then
    return utils.getTermCode("<TAB>")
  else
    vim.fn["coc#refresh"]()
  end
end, {
  silent = true,
  expr = true,
  noremap = true,
})

km_utils.setKeymap("i", "<S-TAB>", function()
  if vim.fn["coc#pum#visible"]() ~= 0 then
    return vim.fn["coc#pum#prev"](1)
  else
    return utils.getTermCode([[<C-h>]])
  end
end, {
  silent = true,
  expr = true,
})

km_utils.setKeymap("n", "gd", "<Plug>(coc-definition)", { silent = true })
km_utils.setKeymap("n", "gr", "<Plug>(coc-references)", { silent = true })
km_utils.setKeymap("n", "g[", "<Plug>(coc-diagnostic-prev)", { silent = true, noremap = true })
km_utils.setKeymap("n", "g]", "<Plug>(coc-diagnostic-next)", { silent = true, noremap = true })

km_utils.setKeymap("n", "<C-p>", function()
  if vim.fn["coc#float#has_float"]() ~= 0 then
    vim.fn["coc#float#jump"]()
  elseif #(vim.fn["coc#float#get_float_win_list"]()) ~= 0 then
    vim.cmd("quit")
  end
end, { noremap = true, silent = true })
