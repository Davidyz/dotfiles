require("treesitter-context").setup({
	enable = true,
	throttle = true,
	max_lines = 0,
	patterns = {
		default = {
			"for",
			"while",
			"if",
			"switch",
			"case",
		},
	},
})
