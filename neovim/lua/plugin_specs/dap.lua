return {
  {
    "mfussenegger/nvim-dap",
    cond = require("_utils").no_vscode,
    config = function()
      local dap = require("dap")
      dap.defaults.fallback.switchbuf = "useopen,usetab,usevisible,newtab"
      vim.api.nvim_create_autocmd(
        "BufEnter",
        { pattern = "[dap-repl]", callback = require("dap.ext.autocompl").attach }
      )
    end,
    keys = {
      { "<F5>", "<cmd>DapContinue<CR>", desc = "DAP Continue." },
      { "<Space>o", "<cmd>DapStepOver<CR>", desc = "DAP Step [O]ver.", noremap = true },
      { "<Space>i", "<cmd>DapStepInto<CR>", desc = "DAP Step [I]nto.", noremap = true },
      { "<Space>q", "<cmd>DapStepOut<CR>", desc = "DAP Step Out.", noremap = true },
      {
        "<Space>s",
        function()
          local widgets = require("dap.ui.widgets")
          local float = widgets.centered_float(widgets.scopes, { border = "solid" })
          vim.keymap.set("n", "q", "<cmd>q<cr>", { noremap = true, buffer = float.buf })
          vim.keymap.set(
            "n",
            "<Space>s",
            "<cmd>q<cr>",
            { noremap = true, buffer = float.buf }
          )
        end,
        desc = "DAP [s]cope",
        noremap = true,
      },
      {
        "<Space>b",
        function()
          local bp = require("dap.breakpoints").get()[vim.api.nvim_get_current_buf()]
          local cursor_pos = vim.api.nvim_win_get_cursor(0)
          if
            vim.iter(bp or {}):any(function(item)
              return item.line == cursor_pos[1]
            end)
          then
            require("dap").toggle_breakpoint()
          else
            vim.ui.input({ prompt = "Breakpoint Condition?" }, function(value)
              if value then
                if value == "" then
                  value = nil
                end
                require("dap").toggle_breakpoint(value)
              end
            end)
          end
        end,
        desc = "DAP Toggle [B]reakpoint.",
        noremap = true,
      },
      {
        "<leader>d",
        function()
          require("dapui").toggle()
        end,
        desc = "Toggle DAP UI.",
      },
    },
    cmd = {
      "DapShowLog",
      "DapContinue",
      "DapToggleBreakpoint",
      "DapToggleRepl",
      "DapStepOver",
      "DapStepInto",
      "DapStepOut",
      "DapTerminate",
      "DapLoadLaunchJSON",
      "DapRestartFrame",
      "DapInstall",
      "DapUninstall",
    },
    dependencies = {
      {
        "theHamsta/nvim-dap-virtual-text",
        opts = {
          enabled = true, -- enable this plugin (the default)
          enabled_commands = true, -- create commands DapVirtualTextEnable, DapVirtualTextDisable, DapVirtualTextToggle, (DapVirtualTextForceRefresh for refreshing when debug adapter did not notify its termination)
          highlight_changed_variables = true, -- highlight changed values with NvimDapVirtualTextChanged, else always NvimDapVirtualText
          highlight_new_as_changed = false, -- highlight new variables in the same way as changed variables (if highlight_changed_variables)
          show_stop_reason = true, -- show stop reason when stopped for exceptions
          commented = false, -- prefix virtual text with comment string
          only_first_definition = true, -- only show virtual text at first definition (if there are multiple)
          all_references = false, -- show virtual text on all all references of the variable (not only definitions)
          filter_references_pattern = "<module", -- filter references (not definitions) pattern when all_references is activated (Lua gmatch pattern, default filters out Python modules)
          -- experimental features:
          virt_text_pos = "eol", -- position of virtual text, see `:h nvim_buf_set_extmark()`
          all_frames = false, -- show virtual text for all stack frames not only current. Only works for debugpy on my machine.
          virt_lines = false, -- show virtual lines instead of virtual text (will flicker!)
          virt_text_win_col = nil, -- position the virtual text at a fixed window column (starting from the first text column) ,
          -- e.g. 80 to position at column 80, see `:h nvim_buf_set_extmark()`
        },
        cond = require("_utils").no_vscode,
      },
      {
        "rcarriga/nvim-dap-ui",
        cond = require("_utils").no_vscode,
        dependencies = { "nvim-neotest/nvim-nio" },
        key = {},
        opts = {
          icons = { expanded = "▾", collapsed = "▸" },
          mappings = {
            -- Use a table to apply multiple mappings
            expand = { "<CR>", "<2-LeftMouse>" },
            open = "o",
            remove = "d",
            edit = "e",
            repl = "r",
            toggle = "t",
          },
          expand_lines = true,
          layouts = {
            -- You can change the order of elements in the sidebar
            {
              elements = {
                "watches",
                "stacks",
                "scopes",
              },
              size = 40,
              position = "left", -- Can be "left", "right", "top", "bottom"
            },
            {
              elements = { "repl", "breakpoints" },
              size = 10,
              position = "bottom", -- Can be "left", "right", "top", "bottom"
            },
          },
          floating = {
            max_height = nil, -- These can be integers or a float between 0 and 1.
            max_width = nil, -- Floats will be treated as percentage of your screen.
            border = "single", -- Border style. Can be "single", "double" or "rounded"
            mappings = {
              close = { "q", "<Esc>" },
            },
          },
          windows = { indent = 2 },
          render = {
            indent = 1,
            -- max_type_length = nil, -- Can be integer or nil.
          },
        },
        config = function(_, opts)
          local dap = require("dap")
          local dapui = require("dapui")
          dapui.setup(opts)
          dap.listeners.before.event_terminated.dapui_config = dapui.close
          dap.listeners.before.event_exited.dapui_config = dapui.close
        end,
      },
      {
        "jay-babu/mason-nvim-dap.nvim",
        cond = require("_utils").no_vscode,
        opts = {
          ensure_installed = { "bash", "cppdbg" },
          automatic_setup = true,
          handlers = {
            function(config)
              require("mason-nvim-dap").default_setup(config)
            end,
          },
        },
      },
      {
        "mfussenegger/nvim-dap-python",
        build = false,
        config = function(_, opts)
          local python_test_runner = "unittest"
          if vim.fn.executable("pytest") == 1 then
            python_test_runner = "pytest"
          end
          require("dap-python").setup(
            require("venv-selector").python() or "python3",
            opts
          )
          require("dap-python").test_runner = python_test_runner
        end,
      },
    },
  },
  {
    "HiPhish/debugpy.nvim",
    cmd = { "Debugpy" },
    cond = function()
      return require("_utils").no_vscode()
    end,
    dependencies = { "mfussenegger/nvim-dap" },
  },
  {
    "Davidyz/coredumpy.nvim",
    cmd = { "Coredumpy" },
    opts = function()
      return { python = nil }
    end,
    cond = function()
      return require("_utils").no_vscode()
    end,
  },
}
