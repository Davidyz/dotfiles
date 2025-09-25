---@module "lazy"

---@type LazySpec
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
  ---@param opts? CatppuccinOptions
  opts = function(_, opts)
    ---@type CatppuccinOptions
    opts = vim.tbl_deep_extend("force", opts or {}, {
      auto_integrations = true,
      float = { solid = true },
      custom_highlights = function(colors)
        return {
          FloatBorder = { fg = colors.mantle, bg = colors.mantle },
          FloatTitle = { fg = colors.lavender, bg = colors.mantle },
          LspInfoBorder = { fg = colors.mantle, bg = colors.mantle },
          WinSeparator = { bg = colors.base, fg = colors.lavender },
          Constant = { fg = colors.lavender },
          ["@lsp.mod.builtin.python"] = { link = "@type.builtin" },
          ["@type.builtin"] = {
            fg = colors.lavender,
            italic = true,
          },
          ["@function.builtin"] = { italic = true },
          ["@lsp.type.property"] = { link = "@attribute" },
          ["@property"] = { link = "@attribute" },
        }
      end,
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
      dim_inactive = { enabled = false },
      flavour = "mocha",
      show_end_of_buffer = true,
      term_colors = true,
    })
    return opts
  end,
}
