local km_utils = require("keymaps.utils")
local utils = require("_utils")

km_utils.setKeymap("i", "<A-j>", vim.fn["copilot#Accept"](utils.getTermCode([[<CR>]])))
