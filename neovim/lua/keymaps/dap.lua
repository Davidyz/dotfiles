local km_utils = require("keymaps.utils")
local dap = require("dap")
local dapui = require("dapui")

km_utils.setKeymap("n", "<Leader>db", dap.toggle_breakpoint)
km_utils.setKeymap("n", "<F5>", dap.continue)
km_utils.setKeymap("n", "<Leader>d", dapui.toggle, { noremap = true })

km_utils.setKeymap("n", "<Leader>do", dap.step_over)
km_utils.setKeymap("n", "<Leader>di", dap.step_into)
km_utils.setKeymap("n", "<Leader>dq", dap.step_out)

km_utils.setKeymap("n", "<Leader>dl", dap.run_last)
km_utils.setKeymap("n", "<Leader>dr", dap.run)
km_utils.setKeymap("n", "<leader>d?", function()
  local widgets = require("dap.ui.widgets")
  widgets.centered_float(widgets.scopes)
end)

km_utils.setKeymap("n", "<Leader>dR", dap.repl.toggle)
