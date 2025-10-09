---@module "lazy"

local utils = require("_utils")
local api = vim.api

---@param place? boolean
---@param cb? function
local function load_cov(place, cb)
  if place == nil then
    place = true
  end
  local cov = require("coverage")
  local suc, status = true, nil
  if not require("coverage.report").is_cached() then
    cov.load(place)
    suc, status = vim.wait(1000, function()
      return require("coverage.report").is_cached()
    end, 10)
  end

  if suc and type(cb) == "function" then
    vim.schedule(function()
      return cb()
    end)
  end
end

---@type LazySpec[]
return {
  {
    "nvim-neotest/neotest",
    config = function()
      local default_python = require("venv-selector").python()
        or vim.fs.joinpath(
          vim.fs.root(0, { ".venv", "pyproject.toml", ".git" }) or ".",
          ".venv/bin/python"
        )

      if utils.is_file(default_python) then
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
          if utils.is_file(buf_name) then
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
          for _, dir in pairs({ "tests", "test" }) do
            local test_dir = vim.fs.joinpath(root_dir, dir)
            if utils.is_directory(test_dir) then
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
      commands = false,
      auto_reload = true,
      signs = { covered = { hl = "LineNr" }, uncovered = { hl = "Exception" } },
      summary = {
        min_coverage = 95.0,
        width_percentage = 0.9,
        height_percentage = 0.8,
        borders = {
          topleft = " ",
          topright = " ",
          top = " ",
          left = " ",
          right = " ",
          botleft = " ",
          botright = " ",
          bot = " ",
        },
        window = { winblend = 0 },
      },
    },
    config = function(_, opts)
      local cov = require("coverage")
      api.nvim_set_hl(0, "CoverageSummaryPass", { link = "LineNr" })
      api.nvim_set_hl(0, "CoverageSummaryFail", { link = "Exception" })
      cov.setup(opts)
      load_cov(false)
    end,
    keys = {
      {
        "]C",
        function()
          load_cov(true, function()
            require("coverage").jump_next("uncovered")
          end)
        end,
        desc = "Next uncovered snippet.",
        noremap = true,
      },
      {
        "[C",
        function()
          load_cov(true, function()
            require("coverage").jump_prev("uncovered")
          end)
        end,
        desc = "Previous uncovered snippet.",
        noremap = true,
      },
      {
        "<leader>Cs",
        function()
          load_cov(true, require("coverage").summary)
        end,
        desc = "[C]overage [s]ummary.",
      },
      {
        "<leader>Ct",
        function()
          load_cov(false, require("coverage").toggle)
        end,
        desc = "[C]overage [t]oggle.",
      },
    },
  },
}
