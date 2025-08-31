return {
  "folke/snacks.nvim",
  submodules = false,
  priority = 1000,
  lazy = false,
  version = "*",
  opts = function()
    return {
      bigfile = { enabled = true },
      dashboard = {
        enabled = true,
        pane_gap = 4,
        sections = {
          { section = "header" },
          { section = "keys", gap = 0, padding = 2 },
          {
            icon = " ",
            title = "Recent Files",
            section = "recent_files",
            indent = 2,
            padding = 2,
            cwd = true,
            file = vim.fn.fnamemodify(".", ":~"),
          },
          {
            icon = " ",
            title = "Projects",
            section = "projects",
            indent = 2,
            enabled = require("snacks").git.get_root() == nil,
            padding = 2,
          },
          {
            pane = 2,
            icon = " ",
            title = "Git Status",
            section = "terminal",
            enabled = require("snacks").git.get_root() ~= nil,
            cmd = "git status --short --branch --renames",
            height = 5,
            padding = 1,
            ttl = 5 * 60,
            indent = 3,
          },
          { section = "startup" },
        },
        preset = {
          keys = {
            {
              icon = " ",
              key = "f",
              desc = "Find File",
              action = function(opts)
                return require("fzf-lua").files(opts)
              end,
            },
            {
              icon = " ",
              key = "n",
              desc = "New File",
              action = ":ene | startinsert",
            },
            {
              icon = " ",
              key = "g",
              desc = "Find Text",
              action = "<cmd>FzfLua grep_project<cr>",
            },
            {
              icon = " ",
              key = "G",
              desc = "Git Files",
              action = "<cmd>FzfLua git_files<cr>",
            },
            {
              icon = "󰒲 ",
              key = "L",
              desc = "Lazy",
              action = ":Lazy",
              enabled = package.loaded.lazy ~= nil,
            },
            { icon = " ", key = "q", desc = "Quit", action = ":q" },
          },
        },
      },
      image = { enabled = false },
      input = { enabled = true },
      notifier = { enabled = true },
      picker = { enabled = true },
      ---@type snacks.profiler.Config
      profiler = {
        enabled = true,
        -- filter_mod = { default = false, codecompanion = true },
        -- filter_fn = { default = false, ["^codecompanion.*"] = true },
      },
      quickfile = { enabled = true },
      rename = { enabled = true },
      statuscolumn = {
        enabled = true,
        left = { "mark", "sign", "git" },
        right = { "fold" },
      },
      words = { enabled = true },
      -- scroll = { animate = { easing = "inOutCirc" } },
      styles = { input = { relative = "cursor", row = -3, col = 0 } },
    }
  end,
  init = function()
    local snacks = require("snacks")
    vim.api.nvim_create_autocmd("User", {
      pattern = "VeryLazy",
      callback = function()
        _G.dd = function(...)
          snacks.debug.inspect(...)
        end

        _G.dt = function(...)
          snacks.debug.backtrace(...)
        end
        vim.print = _G.dd
        -- vim.ui.input = Snacks.input.input
        vim.o.laststatus = 3
        vim.o.showtabline = 2
      end,
    })
  end,
  keys = {
    {
      "<Leader>p",
      function()
        local snacks = require("snacks")
        if snacks.profiler.running() then
          snacks.profiler.stop()
        else
          snacks.profiler.start()
        end
      end,
      desc = "Debug profiler",
    },
    {
      "]r",
      function()
        require("snacks").words.jump(vim.v.count1)
      end,
      desc = "Next Reference",
      mode = { "n", "t" },
    },
    {
      "[r",
      function()
        require("snacks").words.jump(-vim.v.count1)
      end,
      desc = "Prev Reference",
      mode = { "n", "t" },
    },
  },
}
