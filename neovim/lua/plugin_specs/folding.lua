---@module "lazy"

---@type LazySpec[]
return {
  {
    "chrisgrieser/nvim-origami",
    event = "FileType",
    opts = {
      foldtext = { enabled = true },
      useLspFoldsWithTreesitterFallback = true,
    },
    init = function()
      vim.opt.foldlevel = 99
      vim.opt.foldlevelstart = 99
    end,
  },
}
