local function format(command)
  return function()
    if vim.fn.executable(command) then
      vim.api.nvim_command([[:silent! mkview]])
      vim.api.nvim_command([[:%!]] .. command)
      vim.api.nvim_command([[:silent! loadview]])
    end
  end
end
_G.format = format
