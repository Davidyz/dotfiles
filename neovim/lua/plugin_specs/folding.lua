---@module "lazy"

local api = vim.api
local fn = vim.fn

--- Jump to the next/previous fold
---@param direction 1|-1 `1` for next, `-1` for previous
---@param opts? {loop: boolean} whether to search from the other end when reaching top/bottom.
local function jump_to_fold(direction, opts)
  assert(math.abs(direction) == 1, "direction should be 1 or -1.")

  opts = vim.tbl_deep_extend("force", { loop = true }, opts or {})
  return function()
    local curr_pos = fn.getpos(".")

    local line_count = api.nvim_buf_line_count(curr_pos[1])
    local curr_line = curr_pos[2]

    if fn.foldclosed(curr_line) ~= -1 then
      -- already in a fold. start the check from outside of the check
      if direction == 1 then
        curr_line = fn.foldclosedend(curr_line) + 1
      else
        curr_line = fn.foldclosed(curr_line) - 1
      end
    end

    -- make sure the while loop always stops
    local seen_lines = 0

    while seen_lines <= line_count do
      curr_line = curr_line + direction
      if fn.foldclosed(curr_line) ~= -1 then
        curr_pos[2] = curr_line
        return fn.setpos(".", curr_pos)
      end

      seen_lines = seen_lines + 1

      if opts.loop then
        if direction == 1 and curr_line == line_count then
          curr_line = 0
        elseif direction == -1 and curr_line == 1 then
          curr_line = line_count + 1
        end
      end
    end
    return vim.notify("No more folds.")
  end
end

---@type LazySpec[]
return {
  {
    "chrisgrieser/nvim-origami",
    event = "FileType",
    opts = {
      foldtext = { enabled = true },
      useLspFoldsWithTreesitterFallback = true,
    },
    init = function()
      vim.opt.foldmethod = "expr"
      vim.opt.foldlevel = 99
      vim.opt.foldlevelstart = 99
    end,
    keys = {
      {
        "[z",
        jump_to_fold(-1),
        mode = "n",
        desc = "Previous fold",
        noremap = true,
      },
      {
        "]z",
        jump_to_fold(1),
        mode = "n",
        desc = "Next fold",
        noremap = true,
      },
    },
  },
}
