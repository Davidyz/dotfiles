require("utils")

function Set_keymap(mode, action, command, extra_args)
	if extra_args == false then
		extra_args = { noremap = false }
	else
		extra_args = extra_args or { noremap = true }
	end
	vim.api.nvim_set_keymap(mode, action, command, extra_args)
end
