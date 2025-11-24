---@module "lazy"

---@type LazySpec[]
return {
  {
    "kawre/leetcode.nvim",
    cmd = "Leet",
    config = function()
      local lc = require("leetcode")
      local python_imports = {
        "# pyright: reportWildcardImportFromLibrary=false",
        "# pyright: reportUnusedClass=false",
        "# pyright: reportUnusedFunction=false",
        "# pyright: reportUnusedVariable=false",
      }
      local default_python_imports = require("leetcode.config.imports").python3
      for i, v in ipairs(default_python_imports) do
        if string.find(v, "import") ~= nil then
          default_python_imports[i] = v .. " # noqa: F401,F403"
        end
      end
      vim.list_extend(python_imports, default_python_imports)
      lc.setup({
        lang = "python3",
        injector = {
          ["python3"] = { before = python_imports },
        },
      })
    end,
    dependencies = {
      "MunifTanjim/nui.nvim",

      -- optional
      "nvim-treesitter/nvim-treesitter",

      "nvim-mini/mini.icons",
    },
  },
}
