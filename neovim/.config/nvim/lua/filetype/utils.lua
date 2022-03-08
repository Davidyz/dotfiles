local function format(command, args)
  if not (type(args) == "string") then
    args = ""
  end
  return function()
    if vim.fn.executable(command) then
      vim.api.nvim_command([[:silent! mkview]])
      vim.api.nvim_command([[:%!]] .. command .. " " .. args)
      vim.api.nvim_command([[:silent! loadview]])
    end
  end
end
_G.format = format
