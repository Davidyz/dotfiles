local dap = require("dap")
local dapui = require("dapui")
local virtual_text = require("nvim-dap-virtual-text")
local utils = require("_utils")
local scan = require("plenary.scandir")

vim.api.nvim_create_autocmd(
  "BufEnter",
  { pattern = "[dap-repl]", callback = require("dap.ext.autocompl").attach }
)

dapui.setup({
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
  -- Expand lines larger than the window
  -- Requires >= 0.7
  expand_lines = vim.fn.has("nvim-0.7"),
  layouts = {
    -- You can change the order of elements in the sidebar
    {
      elements = {
        -- Provide as ID strings or tables with "id" and "size" keys
        "scopes",
        "breakpoints",
        "stacks",
        "watches",
      },
      size = 40,
      position = "left", -- Can be "left", "right", "top", "bottom"
    },
    {
      elements = { "repl" },
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
  windows = { indent = 1 },
  render = {
    indent = 1,
    max_type_length = nil, -- Can be integer or nil.
  },
})

virtual_text.setup({
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
})

local mason_dap = require("mason-nvim-dap")
mason_dap.setup({
  ensure_installed = { "python", "bash", "cppdbg" },
  automatic_setup = true,
})
