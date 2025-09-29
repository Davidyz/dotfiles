local api = vim.api

api.nvim_create_user_command("CloseHealthyBufs", function(args)
  ---@type string?
  local level = args.args
  if level == "" then
    level = nil
  end
  require("_utils").close_no_diagnostics({ level = level })
end, {
  complete = function(_, _, _)
    return { "ERROR", "WARN", "INFO", "HINT" }
  end,
  nargs = "?",
  desc = "Delete buffers that doesn't contain given (or more serious) diagnostics (inclusive).",
})
