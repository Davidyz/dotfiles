local M = {}
local a = require("plugin_extras.async")
local fn = vim.fn
local api = vim.api

local function dap()
  return require("dap")
end

local function snacks()
  return require("snacks")
end

local function get_session()
  return assert(dap().session(), "No active session!")
end

function M.dap_frames()
  local session = get_session()
  assert(session.stopped_thread_id ~= nil, "Failed to find currently stopped thread!")
  ---@type dap.Thread
  local thread = assert(
    session.threads[session.stopped_thread_id],
    "Failed to find currently stopped thread!"
  )
  if thread.frames == nil then
    return vim.notify("No StackFrame.")
  end
  local frames = assert(thread.frames)

  local num_frames = #frames
  local resolved_count = 0

  ---@type table<integer, {path: string?, content: string?}>
  local sources = {}
  local start_picker = function()
    snacks().picker({
      title = "DAP StackFrame",
      items = vim
        .iter(frames)
        :filter(
          ---@param frame dap.StackFrame
          function(frame)
            return sources[frame.id] ~= nil
          end
        )
        :map(
          ---@param frame dap.StackFrame
          ---@return snacks.picker.Item
          function(frame)
            ---@type snacks.picker.Item
            local item = {
              idx = frame.id,
              score = 1,
              pos = { frame.line, frame.column },
              text = frame.name,
            }
            if sources[frame.id].path then
              item.file = sources[frame.id].path
            else
              item.preview = { text = sources[frame.id].content, ft = session.filetype }
            end

            return item
          end
        )
        :totable(),
    })
  end

  local done = false
  vim.iter(frames):each(
    ---@param frame dap.StackFrame
    function(frame)
      if frame.source == nil then
        resolved_count = resolved_count + 1
      elseif frame.source.path then
        sources[frame.id] = { path = frame.source.path }
        resolved_count = resolved_count + 1
      elseif frame.source.sourceReference then
        session:request(
          "source",
          { sourceReference = frame.source.sourceReference },
          ---@param result dap.SourceResponse
          function(err, result)
            resolved_count = resolved_count + 1
            if result.content then
              sources[frame.id] = { content = result.content }
            end

            if resolved_count == num_frames and not done then
              done = true
              return start_picker()
            end
          end
        )
      end

      if resolved_count == num_frames and not done then
        done = true
        return start_picker()
      end
    end
  )
end

function M.dap_breakpoints()
  local bufnr, line, col, _ = unpack(fn.getpos("."))
  if bufnr == 0 then
    bufnr = api.nvim_get_current_buf()
  end

  local items = {}
  for _bufnr, bps in pairs(require("dap.breakpoints").get()) do
    local fname = vim.uri_to_fname(vim.uri_from_bufnr(_bufnr))
    vim.iter(bps):each(function(bp)
      items[#items + 1] = {
        file = fname,
        idx = bp.line,
        pos = { bp.line, 0 },
        text = api.nvim_buf_get_lines(_bufnr, bp.line, bp.line + 1, false)[1],
        score = 1,
      }
    end)
  end

  snacks().picker({
    title = "DAP breakpoints",
    items = items,
  })
end

function M.dap_variables()
  local session = get_session()
  assert(session.stopped_thread_id ~= nil, "Failed to find currently stopped thread!")
  ---@type dap.Thread
  local thread = assert(
    session.threads[session.stopped_thread_id],
    "Failed to find currently stopped thread!"
  )

  local frame = assert(session.current_frame, "Failed to find current frame.")
  assert(frame.scopes, "Failed to find any scopes.")

  local idx = 0

  ---@type table<integer, dap.Variable>
  local items = {}

  snacks().picker({
    source = "select",
    title = "DAP variables",
    win = { preview = { show = false } },
    format = function(item, picker)
      ---@type dap.Variable
      local var = items[item.idx]

      local hl_group_name = string.format("@lsp.type.%s", var.type or "variable")

      if
        vim.tbl_isempty(api.nvim_get_hl(0, { name = hl_group_name, create = false }))
      then
        hl_group_name = "Variable"
      end

      return {
        { var.name, hl_group_name },
        { ": ", "Comment" },
        { var.value, "Variable" },
      }
    end,
    items = vim
      .iter(frame.scopes or {})
      :map(
        ---@param scope dap.Scope
        function(scope)
          return vim
            .iter(scope.variables or {})
            :map(
              ---@param var dap.Variable
              function(var)
                idx = idx + 1
                items[idx] = var
                ---@type snacks.picker.Item
                return {
                  text = string.format("%d %s: %s", idx, var.name, var.value),
                  idx = idx,
                  score = 1,
                }
                -- return string.format("%s: %s", var.name, var.value)
              end
            )
            :totable()
        end
      )
      :flatten(1)
      :totable(),
    actions = {
      confirm = function(picker, item)
        local var = items[item.idx]
        if var.evaluateName then
          session:evaluate(var.evaluateName, function(err, result)
            if result ~= nil then
              vim.schedule(function()
                vim.notify(string.format(
                  [[`%s` evaluates to: 

```%s
%s
```]],
                  var.name,
                  session.filetype,
                  result.result
                ))
              end)
            end
          end)
        end
        local loc_ref = var.valueLocationReference or var.declarationLocationReference
        if loc_ref then
          session:request(
            "locations",
            { locationReference = loc_ref },
            ---@param loc_result dap.LocationsResponse
            function(err, loc_result)
              if loc_result.source.path then
                snacks().picker.actions.jump(
                  picker,
                  vim.tbl_deep_extend(
                    "force",
                    item,
                    { pos = { loc_result.line, loc_result.column } }
                  )
                )
              end
            end
          )
        end
        picker:close()
      end,
    },
  })
end

return M
