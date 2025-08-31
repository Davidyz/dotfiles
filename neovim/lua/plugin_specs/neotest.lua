---@module "lazy"

---@type LazySpec[]
return {
  {
    "nvim-neotest/neotest",
    commit = "52fca67", -- workaround for `test not found` bug.
    config = function()
      local default_python = require("venv-selector").python()
        or vim.fs.joinpath(
          vim.fs.root(0, { ".venv", "pyproject.toml", ".git" }) or ".",
          ".venv/bin/python"
        )
      local stat = vim.uv.fs_stat(default_python)
      if not stat or stat.type ~= "file" then
        default_python = "python"
      end
      require("neotest").setup({
        adapters = {
          require("neotest-python")({
            dap = { justMyCode = true },
            args = { "--log-level", "DEBUG" },
            runner = "pytest",
            python = default_python,
          }),
        },
      })

      vim.api.nvim_create_autocmd("FileType", {
        pattern = "neotest-*",
        callback = function()
          for _, lhs in pairs({ "q", "<esc>" }) do
            vim.keymap.set("n", lhs, function()
              vim.cmd("quit")
            end, { buffer = 0 })
          end
        end,
      })
    end,
    version = "*",
    keys = {
      {
        "<Space>tf",
        function()
          require("neotest").run.run()
        end,
        desc = "[T]est nearest [f]unction",
      },
      {
        "<Space>tF",
        function()
          require("neotest").run.run({ strategy = "dap" })
        end,
        desc = "[T]est nearest [f]unction (dap)",
      },
      {
        "<Space>to",
        function()
          require("neotest").output.open({ short = true, enter = true })
        end,
        desc = "[T]est [o]utput",
      },
      {
        "<Space>ts",
        function()
          require("neotest").run.stop()
        end,
        desc = "[S]top",
      },
      {
        "<Space>ta",
        function()
          require("neotest").run.attach()
        end,
        desc = "[A]ttach to [t]est",
      },
      {
        "<Space>ta",
        function()
          local buf_name = vim.api.nvim_buf_get_name(0)
          local stat = vim.uv.fs_stat(buf_name)
          if stat ~= nil and stat.type == "file" then
            require("neotest").run.run(buf_name)
            require("neotest").summary.open()
          end
        end,
        desc = "[T]est [a]ll cases in current file",
      },
      {
        "<Space>tA",
        function()
          local root_dir = vim.fs.root(0, { "tests", "test" })
          if root_dir == nil then
            return
          end
          local stat
          for _, dir in pairs({ "tests", "test" }) do
            local test_dir = vim.fs.joinpath(root_dir, dir)
            stat = vim.uv.fs_stat(test_dir)
            if stat and stat.type == "directory" then
              require("neotest").run.run(test_dir)
              require("neotest").summary.open()
              return
            end
          end
        end,
        desc = "Run all tests.",
      },
    },
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
  },
  { "nvim-neotest/neotest-python", ft = { "python" } },
  {
    "andythigpen/nvim-coverage",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      commands = true,
      auto_reload = true,
      signs = { covered = { hl = "LineNr" }, uncovered = { hl = "Exception" } },
    },
    config = function(_, opts)
      local cov = require("coverage")
      cov.setup(opts)
      cov.load(true)
    end,
    keys = {
      {
        "]C",
        function()
          require("coverage").jump_next("uncovered")
        end,
        desc = "Next uncovered snippet.",
        noremap = true,
      },
      {
        "[C",
        function()
          require("coverage").jump_prev("uncovered")
        end,
        desc = "Previous uncovered snippet.",
        noremap = true,
      },
    },
    cmd = { "Coverage" },
  },
}
