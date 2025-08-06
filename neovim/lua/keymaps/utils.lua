local M = {}
-- @param mode string
-- @param keys string
function M.setKeymap(mode, keys, command, extra_args)
  if extra_args == false then
    extra_args = { noremap = false }
  else
    extra_args = extra_args or { noremap = true }
  end
  if type(command) == "function" then
    extra_args.callback = command
    command = ""
  end
  vim.api.nvim_set_keymap(mode, keys, command, extra_args)
end

--- Jump to the file if already opened in an existing tab. Otherwise open in new tab.
M.fzf_lua_jump_action = function(selected, opts)
  local actions = require("fzf-lua.actions")
  local path = require("fzf-lua.path")

  if #selected == 0 then
    return
  end
  local entry = path.entry_to_file(selected[1], opts, false)
  local uri = vim.uri_from_fname(entry.path) or vim.uri_from_bufnr(entry.bufnr)
  if uri == nil then
    return
  end
  for _, tab in ipairs(vim.api.nvim_list_tabpages()) do
    for _, win in ipairs(vim.api.nvim_tabpage_list_wins(tab)) do
      if vim.uri_from_bufnr(vim.api.nvim_win_get_buf(win)) == uri then
        vim.api.nvim_set_current_win(win)
        if entry.line > 0 or entry.col > 0 then
          pcall(
            vim.api.nvim_win_set_cursor,
            win,
            { math.max(1, entry.line), math.max(1, entry.col) - 1 }
          )
        end
        return
      end
    end
  end
  return actions.buf_tabedit(selected, opts)
end

return M
