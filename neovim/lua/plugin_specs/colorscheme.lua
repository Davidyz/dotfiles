return {
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000,
  config = function(_, opts)
    require("catppuccin").setup(opts)
    vim.cmd.colorscheme("catppuccin")
    vim.api.nvim_set_hl(0, "CursorColumn", { link = "CursorLine" })
  end,
  lazy = false,
  opts = function()
    local flavour = "mocha"
    return {
      flavour = flavour,
      term_colors = true,
      custom_highlights = function(colors)
        return {
          FloatBorder = { fg = colors.mantle, bg = colors.mantle },
          FloatTitle = { fg = colors.lavender, bg = colors.mantle },
          LspInfoBorder = { fg = colors.mantle, bg = colors.mantle },
          WinSeparator = { bg = colors.base, fg = colors.lavender },
        }
      end,
      dim_inactive = { enabled = false },
      auto_integrations = true,
      default_integrations = {
        blink_cmp = { style = "solid" },
        diffview = true,
        fidget = true,
        fzf = true,
        headlines = true,
        hop = true,
        lspsaga = true,
        mason = true,
        mini = { enabled = true },
        native_lsp = { enabled = true },
        navic = { enabled = true },
        neotree = true,
        nvim_surround = true,
        rainbow_delimiters = true,
        snacks = { enabled = true },
        which_key = true,
      },
    }
  end,
}
