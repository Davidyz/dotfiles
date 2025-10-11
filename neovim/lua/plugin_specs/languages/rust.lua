---@module "lazy"

---@type LazySpec[]
return {
  {
    "mrcjkb/rustaceanvim",
    version = "^6",
    ---@module "rustaceanvim"
    ---@type rustaceanvim.Opts
    opts = {},
    config = function(self, opts)
      vim.g.rustaceanvim = function()
        return opts
      end
    end,
    ft = { "rust" },
  },
}
