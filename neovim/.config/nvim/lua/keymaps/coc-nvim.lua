local km_utils = require("keymaps.utils")
local utils = require("utils")

local function show_doc()
  if
    utils.contains({ "vim", "help" }, vim.bo.filetype)
    or string.match(vim.fn.getline("."), "vim%." .. "%w+%." .. vim.fn.expand("<cword>") .. "%(")
  then
    vim.api.nvim_exec("h " .. vim.fn.expand("<cword>"), {})
  elseif vim.fn["coc#rpc#ready"] then
    vim.fn["CocActionAsync"]("doHover")
  else
    vim.api.nvim_exec("!" .. vim.api.nvim_get_option("keywordprg") .. " " .. vim.fn.expand("<cword>"), {})
  end
end

function _G.check_back_space()
  local col = vim.fn.col(".") - 1
  local line = vim.fn.getline(".")[col - 1] or ""
  return (col > 1) or string.match(line, "%s") ~= nil
end

km_utils.setKeymap("n", "K", show_doc, { silent = true, noremap = true })
km_utils.setKeymap("x", "<leader>a", "<Plug>(coc-codeaction-selected)", false)
km_utils.setKeymap("n", "<leader>a", "<Plug>(coc-codeaction-selected)", false)
km_utils.setKeymap("n", "<leader>r", "<Plug>(coc-rename)", false)
km_utils.setKeymap("n", "<leader>f", "<Plug>(coc-fix-current)", false)

km_utils.setKeymap("i", "<cr>", [[pumvisible() ? coc#_select_confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"]], {
  silent = true,
  expr = true,
  noremap = true,
})
km_utils.setKeymap("i", "<C-space>", vim.fn["coc#refresh"], { silent = true, expr = true, noremap = true })

km_utils.setKeymap("i", "<TAB>", [[pumvisible() ? "\<C-n>" : "\<TAB>"]], {
  silent = true,
  expr = true,
  noremap = true,
})

km_utils.setKeymap("i", "<S-TAB>", function()
  if vim.fn.pumvisible() then
    return utils.getTermCode([[<C-p>]])
  else
    return utils.getTermCode([[<C-h>]])
  end
end, {
  silent = true,
  expr = true,
})

km_utils.setKeymap("n", "gd", "<Plug>(coc-definition)", { silent = true })
km_utils.setKeymap("n", "gr", "<Plug>(coc-references)", { silent = true })
