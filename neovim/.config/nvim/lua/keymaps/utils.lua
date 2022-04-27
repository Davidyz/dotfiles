local M = {}
-- @param mode string
-- @param keys string
function M.setKeymap(mode, keys, command, extra_args)
  if extra_args == false then
    extra_args = { noremap = false }
  else
    extra_args = extra_args or { noremap = true }
  end
  if type(command) == "string" then
    vim.api.nvim_set_keymap(mode, keys, command, extra_args)
  elseif type(command) == "function" then
    extra_args.callback = command
    vim.api.nvim_set_keymap(mode, keys, "", extra_args)
  end
end

return M
