local utils = require("_utils")
local plugin_utils = require("plugins.utils")
local alpha = require("alpha")
local startify = require("alpha.themes.startify")
local dashboard = require("alpha.themes.dashboard")

startify.section.header.val = plugin_utils.make_pokemon()
dashboard.section.header.val = plugin_utils.make_pokemon()

require("alpha").setup(startify.config)
