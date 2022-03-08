local function format(command, args)
  if not (type(args) == "string") then
    args = ""
  end
  return function()
    if vim.fn.executable(command) then
      if vim.b.coc_diagnostic_info ~= nil and vim.b.coc_diagnostic_info["error"] == 0 then
        vim.api.nvim_command([[:silent! mkview]])
        vim.api.nvim_command([[:%!]] .. command .. " " .. args)
        vim.api.nvim_command([[:silent! loadview]])
      else
        vim.api.nvim_command([[echo "Please fix syntax error."]])
      end
    else
      vim.api.nvim_command([[echo "Formatter ]] .. command([[ is not found."]]))
    end
  end
end
_G.format = format
