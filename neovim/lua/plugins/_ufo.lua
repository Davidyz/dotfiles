vim.o.foldcolumn = "0" -- '0' is not bad
vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
vim.o.foldlevelstart = 99
vim.o.foldenable = true

vim.keymap.set("n", "zR", require("ufo").openAllFolds)
vim.keymap.set("n", "zM", require("ufo").closeAllFolds)

local handler = function(virtText, lnum, endLnum, width, truncate)
  local newVirtText = {}
  local suffix = (" 󰁂 %d "):format(endLnum - lnum)
  local sufWidth = vim.fn.strdisplaywidth(suffix)
  local targetWidth = width - sufWidth
  local curWidth = 0
  for _, chunk in ipairs(virtText) do
    local chunkText = chunk[1]
    local chunkWidth = vim.fn.strdisplaywidth(chunkText)
    if targetWidth > curWidth + chunkWidth then
      table.insert(newVirtText, chunk)
    else
      chunkText = truncate(chunkText, targetWidth - curWidth)
      local hlGroup = chunk[2]
      table.insert(newVirtText, { chunkText, hlGroup })
      chunkWidth = vim.fn.strdisplaywidth(chunkText)
      -- str width returned from truncate() may less than 2nd argument, need padding
      if curWidth + chunkWidth < targetWidth then
        suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
      end
      break
    end
    curWidth = curWidth + chunkWidth
  end
  table.insert(newVirtText, { suffix, "MoreMsg" })
  return newVirtText
end

local alternative_handler = function(virt_text, lnum, end_lnum, width, truncate)
  local result = {}
  local _end = end_lnum - 1
  local final_text = vim.trim(vim.api.nvim_buf_get_text(0, _end, 0, _end, -1, {})[1])
  local suffix = final_text:format(end_lnum - lnum)
  local suffix_width = vim.fn.strdisplaywidth(suffix)
  local target_width = width - suffix_width
  local cur_width = 0
  for _, chunk in ipairs(virt_text) do
    local chunk_text = chunk[1]
    local chunk_width = vim.fn.strdisplaywidth(chunk_text)
    if target_width > cur_width + chunk_width then
      table.insert(result, chunk)
    else
      chunk_text = truncate(chunk_text, target_width - cur_width)
      local hl_group = chunk[2]
      table.insert(result, { chunk_text, hl_group })
      chunk_width = vim.fn.strdisplaywidth(chunk_text)
      -- str width returned from truncate() may less than 2nd argument, need padding
      if cur_width + chunk_width < target_width then
        suffix = suffix .. (" "):rep(target_width - cur_width - chunk_width)
      end
      break
    end
    cur_width = cur_width + chunk_width
  end
  table.insert(result, { " ⋯ ", "NonText" })
  table.insert(result, { suffix, "TSPunctBracket" })
  return result
end

require("ufo").setup({
  fold_virt_text_handler = alternative_handler,
  provider_selector = function(bufnum, filetype, buftype)
    local clients = vim.lsp.get_active_clients({ { bufnr = bufnum } })
    for k, v in pairs(clients) do
      if v.config.name == "null-ls" then
        -- ignore null-ls
        clients[k] = nil
      end
    end
    if next(clients) ~= nil then
      return { "treesitter", "lsp" }
    end
    return { "treesitter", "indent" }
  end,
})
