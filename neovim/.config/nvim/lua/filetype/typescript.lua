local languages = { "javascript", "typescript" }

for _, lang in ipairs(languages) do
	vim.api.nvim_command([[autocmd FileType ]] .. lang .. [[ setlocal ts=2 autoindent shiftwidth=0]])
end
