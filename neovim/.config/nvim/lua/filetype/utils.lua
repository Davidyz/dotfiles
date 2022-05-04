local M = {}

-- @param command string
-- @param args string
-- @return function
M.format = function(command, args)
  if not (type(args) == "string") then
    args = ""
  end
  return function()
    if vim.fn.executable(command) and (vim.g.auto_format == nil or vim.g.auto_format == 1) then
      if vim.b.coc_diagnostic_info == nil or vim.b.coc_diagnostic_info["error"] == 0 then
        vim.api.nvim_command([[:silent! mkview]])
        vim.api.nvim_command([[:%!]] .. command .. " " .. args)
        vim.api.nvim_command([[:silent! loadview]])
      else
        vim.api.nvim_command([[echo "Please fix syntax error."]])
      end
    else
      vim.api.nvim_command([[echo "Formatter ]] .. command .. [[ is not found."]])
    end
  end
end

-- @param ftype string
-- @param lines table
-- @param cond function
-- @param cursor_line integer
M.initTemplate = function(ftype, lines, cond, cursor_line)
  if cond == nil or (type(cond) == "function" and cond()) then
    for i, l in ipairs(lines) do
      vim.fn.setline(i, l)
    end
  end
  if type(cursor_line) == "number" then
    vim.fn.cursor(cursor_line, 0)
  end
end

return M
