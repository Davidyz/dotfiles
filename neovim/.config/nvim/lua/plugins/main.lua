local utils = require("_utils")
local lazy_config = require("plugins._lazy")

require("lazy").setup(lazy_config.plugins, lazy_config.config)
