local M = {}

local utils = require("_utils")

---@param rhs string|function|table<filetype, string|fun():string?>
---@return string|function
function M.make_keymap_callback(rhs)
	---@type string|function
	local callback
	if type(rhs) == "table" then
		callback = function()
			return (rhs[vim.bo.filetype] or rhs[1] or rhs["*"] or function()
				vim.schedule_wrap(vim.notify)("Nothing is mapped for this combination.")
			end)()
		end
	else
		---@cast rhs -table
		callback = rhs
	end
	return callback
end

--- Jump to the file if already opened in an existing tab. Otherwise open in new tab.
M.fzf_lua_jump_action = function(selected, opts)
	local actions = require("fzf-lua.actions")
	local path = require("fzf-lua.path")

	if #selected == 0 then
		return
	end
	if
		not vim.iter(vim.api.nvim_tabpage_list_wins(vim.api.nvim_get_current_tabpage())):any(function(win)
			local buf = vim.api.nvim_win_get_buf(win)
			local fname = vim.uri_to_fname(vim.uri_from_bufnr(buf))
			if fname then
				return utils.is_file(fname)
			end
			return false
		end)
	then
		-- do not open in new tab if current tab doesn't contain a file
		return actions.buf_edit(selected, opts)
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
					pcall(vim.api.nvim_win_set_cursor, win, { math.max(1, entry.line), math.max(1, entry.col) - 1 })
				end
				return
			end
		end
	end
	return actions.buf_tabedit(selected, opts)
end

return M
