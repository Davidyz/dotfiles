local fn = vim.fn
local api = vim.api

local function pick_profiler()
  local snacks = require("snacks")
  if snacks.profiler.running() then
    snacks.profiler.stop()
  end
  vim.ui.input({ prompt = "Filter?", default = "" }, function(value)
    local specs = nil
    if value == "" then
    elseif value ~= nil then
      if value:find("^%^") == nil then
        value = "^" .. value
      end
      specs = { filter = { name = value } }
    end
    snacks.profiler.pick(specs)
  end)
end

---@module "lazy"
---@type LazySpec[]
return {
  {
    "folke/snacks.nvim",
    dependencies = {
      {
        "folke/todo-comments.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = {
          signs = false,
          highlight = { multiline = false, keyword = "bg", after = "" },
        },
      },
    },
    -- dir = "~/git/snacks.nvim/",
    submodules = false,
    priority = 1000,
    lazy = false,
    version = "*",
    opts = function()
      ---@module "snacks"
      ---@type snacks.plugins.Config
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
              file = fn.fnamemodify(".", ":~"),
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
                  require("snacks").picker.files()
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
                action = function()
                  require("snacks").picker.grep()
                end,
              },
              {
                icon = " ",
                key = "G",
                desc = "Git Files",
                action = function()
                  require("snacks").picker.git_files()
                end,
              },
              {
                icon = "󰒲 ",
                key = "L",
                desc = "Lazy",
                action = ":Lazy",
                enabled = package.loaded.lazy ~= nil,
              },
              {
                icon = "",
                key = "M",
                desc = "Mason",
                action = function()
                  require("mason.api.command").Mason()
                end,
              },
              {
                icon = " ",
                key = "q",
                desc = "Quit",
                action = function()
                  vim.cmd.quit()
                end,
              },
            },
          },
        },
        gh = { enabled = fn.executable("gh") == 1 },
        image = { enabled = false },
        input = { enabled = true },
        notifier = { enabled = true },
        ---@type snacks.picker.Config
        picker = {
          enabled = true,
          ui_select = true,
          layouts = {
            default = {
              layout = {
                backdrop = false,
                box = "horizontal",
                width = 0.9,
                height = 0.9,
                border = "solid",
                {
                  box = "vertical",
                  border = "solid",
                  title = "{title} {live} {flags}",
                  { win = "input", height = 1, border = "bottom" },
                  { win = "list", border = "none" },
                },
                {
                  win = "preview",
                  title = "{preview}",
                  border = "solid",
                  width = 0.55,
                },
              },
            },
            vertical = {
              layout = {
                backdrop = false,
                width = 0.9,
                min_width = 80,
                height = 0.9,
                min_height = 30,
                box = "vertical",
                border = "solid",
                title = "{title} {live} {flags}",
                title_pos = "center",
                { win = "input", height = 1, border = "solid" },
                { win = "list", border = "none" },
                {
                  win = "preview",
                  title = "{preview}",
                  height = 0.6,
                  border = "solid",
                },
              },
            },
          },
          sources = { grep = { need_search = false, live = false } },
          previewers = { diff = { builtin = false } },
          actions = {
            select = function(picker)
              picker.list:select()
            end,
            confirm = { action = "confirm", cmd = "tabdrop" },
          },
          layout = {
            preset = function()
              return vim.o.columns >= 120 and "default" or "vertical"
            end,
          },
          jump = { reuse_win = false },
          win = {
            input = {
              keys = {
                ["<S-Tab>"] = {
                  "select",
                  mode = { "n", "x", "i" },
                },
                ["<Tab>"] = { "select", mode = { "n", "x", "i" } },
              },
            },
            list = {
              keys = {
                ["<S-Tab>"] = {
                  "select",
                  mode = { "n", "x", "i" },
                },
                ["<Tab>"] = { "select", mode = { "n", "x", "i" } },
              },
            },
            preview = { wo = { cursorcolumn = false } },
          },
          matcher = { frecency = true, history_bonus = true, sort_empty = true },
        },
        profiler = {
          enabled = true,
          on_stop = { pick = false },
          filter_mod = {
            default = true,
            ["^vim%."] = true,

            ["^vim%.lsp%."] = true,
            ["^vim%.api%."] = true,
          },
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
      api.nvim_create_autocmd("User", {
        pattern = "VeryLazy",
        callback = function()
          ---@diagnostic disable-next-line: duplicate-set-field
          _G.dd = function(...)
            snacks.debug.inspect(...)
          end

          ---@diagnostic disable-next-line: duplicate-set-field
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
            pick_profiler()
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

      -- NOTE: picker
      {
        "<leader>tt",
        function()
          require("snacks").picker(require("todo-comments.snacks").source)
        end,
        desc = "Todo comments",
      },
      {
        "<Leader>tf",
        function()
          require("snacks").picker.files()
        end,
        remap = false,
        mode = "n",
        desc = "Fuzzy find files.",
      },
      {
        "<Leader>tb",
        function()
          require("snacks").picker.buffers()
        end,
        remap = false,
        mode = "n",
        desc = "Show buffers.",
      },
      {
        "<Leader>tq",
        function()
          require("snacks").picker.qflist()
        end,
        remap = false,
        mode = "n",
        desc = "Show quickfix.",
      },
      {
        "<Leader>tD",
        function()
          require("snacks").picker.diagnostics()
        end,
        remap = false,
        mode = "n",
        desc = "Project-wise diagnostics.",
      },
      {
        "<Leader>td",
        function()
          require("snacks").picker.diagnostics_buffer()
        end,
        remap = false,
        mode = "n",
        desc = "Buffer diagnostics.",
      },
      {
        "<Leader>th",
        function()
          require("snacks").picker.help()
        end,
        remap = false,
        mode = "n",
        desc = "Find help tags.",
      },
      {
        "<Leader>tH",
        function()
          require("snacks").picker.highlights()
        end,
        remap = false,
        mode = "n",
        desc = "Find highlight groups.",
      },
      {
        "R",
        function()
          require("snacks").picker.grep()
        end,
        remap = false,
        mode = "n",
        desc = "Live grep.",
      },
      {
        "<Leader>f",
        function()
          require("snacks").picker({
            finder = "lines",
            format = "lines",
            jump = { match = true },
            -- allow any window to be used as the main window
            main = { current = true },
            ---@param picker snacks.Picker
            on_show = function(picker)
              local cursor = api.nvim_win_get_cursor(picker.main)
              local info = api.nvim_win_call(picker.main, vim.fn.winsaveview)
              picker.list:view(cursor[1], info.topline)
              picker:show_preview()
            end,
            sort = { fields = { "score:desc", "idx" } },
          })
        end,
        remap = false,
        mode = "n",
        desc = "Fuzzy find current buffer.",
      },
      {
        "<Leader>tr",
        function()
          require("snacks").picker.resume()
        end,
        remap = false,
        mode = "n",
        desc = "Resume last picker session",
      },
      {
        "<Space>df",
        function()
          require("plugin_extras.snacks").dap.dap_frames()
        end,
        remap = false,
        mode = "n",
        desc = "[D]ap [f]rames",
      },
      {
        "<Space>dv",
        function()
          require("plugin_extras.snacks").dap.dap_variables()
        end,
        remap = false,
        mode = "n",
        desc = "[D]ap [v]ariables",
      },
      {
        "<Space>db",
        function()
          return require("plugin_extras.snacks").dap.dap_breakpoints()
        end,
        remap = false,
        mode = "n",
        desc = "[D]ap [b]reakpoints",
      },
      {
        "<Leader>P",
        pick_profiler,
        mode = "n",
        remap = false,
        desc = "Snacks profiler",
      },
      {
        "<Leader>tp",
        function()
          require("snacks").picker()
        end,
        desc = "Show all pickers",
        mode = "n",
        remap = false,
      },

      {
        "<Leader>tgi",
        function()
          require("snacks").gh.issue()
        end,
        desc = "Github issues",
      },
      {
        "<Leader>tgp",
        function()
          require("snacks").gh.pr()
        end,
        desc = "Github PRs",
      },
    },
  },
}
