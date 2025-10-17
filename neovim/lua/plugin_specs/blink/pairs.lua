---@module "blink.pairs"

local api = vim.api

return {
  "saghen/blink.pairs",
  version = "*",
  dependencies = "saghen/blink.download",
  ---@param opts blink.pairs.Config
  ---@return blink.pairs.Config
  opts = function(_, opts)
    api.nvim_set_hl(0, "BlinkPairsMatchParen", {})
    api.nvim_set_hl(0, "BlinkPairsMatchParen", { bold = true })

    opts = vim.tbl_deep_extend("force", opts or {}, {
      ---@type blink.pairs.MappingsConfig
      mappings = {
        enabled = true,
        -- cmdline = true,
        disabled_filetypes = {},
        pairs = {},
      },
      highlights = {
        enabled = true,
        groups = {
          "RainbowDelimiterRed",
          "RainbowDelimiterOrange",
          "RainbowDelimiterYellow",
          "RainbowDelimiterGreen",
          "RainbowDelimiterCyan",
          "RainbowDelimiterBlue",
          "RainbowDelimiterViolet",
        },
        -- groups = vim
        --   .iter(vim.fn.range(1, 7))
        --   :map(function(n)
        --     -- catppuccin defines rainbow hl groups from 1 to 6.
        --     -- this doesn't include yellow, which is reserved for the matching pair.
        --     return string.format("rainbow%d", n % 6 + 1)
        --   end)
        --   :totable(),
        -- unmatched_group = "BlinkPairsUnmatched",

        -- highlights matching pairs under the cursor
        matchparen = {
          enabled = true,
          -- known issue where typing won't update matchparen highlight, disabled by default
          -- cmdline = false,
          group = "BlinkPairsMatchParen",
        },
      },
      debug = false,
    })
    return opts
  end,
  event = { "BufReadPost", "BufNewFile", "CmdlineEnter" },
}
