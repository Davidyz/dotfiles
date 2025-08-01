local dap = require("dap")
local dapui = require("dapui")
local virtual_text = require("nvim-dap-virtual-text")
local utils = require("_utils")
local scan = require("plenary.scandir")

vim.api.nvim_create_autocmd(
  "BufEnter",
  { pattern = "[dap-repl]", callback = require("dap.ext.autocompl").attach }
)

dap.defaults.fallback.switchbuf = "useopen,usetab,usevisible,newtab"
dap.configurations.lua = {
  {
    type = "nlua",
    request = "attach",
    name = "Attach to running Neovim instance",
  },
}

dap.adapters.nlua = function(callback, config)
  callback({
    type = "server",
    host = config.host or "127.0.0.1",
    port = config.port or 8086,
  })
end

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
  ensure_installed = { "bash", "cppdbg" },
  automatic_setup = true,
  handlers = {
    function(config)
      mason_dap.default_setup(config)
    end,
  },
})

dap.listeners.on_config["dap-repl-highlight"] = function(config)
  config = vim.deepcopy(config)
  if config.type == "debugpy" then
    config.repl_lang = config.repl_lang or "python"
  end
  return config
end

-- dap.listeners.before.attach.dapui_config = dapui.open
-- dap.listeners.before.launch.dapui_config = dapui.open
dap.listeners.before.event_terminated.dapui_config = dapui.close
dap.listeners.before.event_exited.dapui_config = dapui.close
