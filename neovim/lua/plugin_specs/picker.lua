local api = vim.api
local utils = require("_utils")
local keymap_utils = require("keymaps.utils")
local function fzf_notification()
  ---@type snacks.notifier.Notif[]
  local notifications = require("snacks").notifier.get_history({ reverse = false })
  ---@type table<string, snacks.notifier.Notif>
  local entries = {}
  for _, noti in ipairs(notifications) do
    local first_line = noti.msg:gsub("\n.*", "")
    entries[string.format("%s %s", utils.make_display_time(noti.added), first_line)] =
      noti
  end

  local fzf_lua = require("fzf-lua")
  local builtin = require("fzf-lua.previewer.builtin")

  -- Inherit from "base" instead of "buffer_or_file"
  local MyPreviewer = builtin.base:extend()

  function MyPreviewer:new(o, opts, fzf_win)
    MyPreviewer.super.new(self, o, opts, fzf_win)
    setmetatable(self, MyPreviewer)
    return self
  end

  function MyPreviewer:populate_preview_buf(entry_str)
    local tmpbuf = self:get_tmp_buffer()
    local replacement = {
      string.format("%s", entry_str),
    }
    local entry = entries[entry_str]
    if entry then
      replacement = vim.split(entry.msg, "\n", { plain = true, trimempty = false })
    end
    api.nvim_buf_set_lines(tmpbuf, 0, -1, false, replacement)
    if entry.ft ~= nil then
      vim.schedule(function()
        vim.bo[tmpbuf].filetype = entry.ft
      end)
    end
    self:set_preview_buf(tmpbuf)
    self.win:update_preview_scrollbar()
  end

  function MyPreviewer:gen_winopts()
    local new_winopts = {
      wrap = false,
      number = true,
    }
    return vim.tbl_extend("force", self.winopts, new_winopts)
  end

  ---@type string[]
  local entry_lines = vim.tbl_keys(entries)
  table.sort(entry_lines, function(a, b)
    return entries[a].added > entries[b].added
  end)

  return fzf_lua.fzf_exec(entry_lines, {
    previewer = MyPreviewer,
    prompt = "Notifications > ",
    actions = {
      ["enter"] = function(selected)
        for _, line in ipairs(selected) do
          local entry = assert(entries[line])
          local temp_buf = api.nvim_create_buf(false, true)
          api.nvim_buf_set_lines(
            temp_buf,
            0,
            -1,
            false,
            vim.split(entry.msg, "\n", { plain = true, trimempty = false })
          )

          if entry.ft ~= nil then
            vim.schedule(function()
              vim.bo[temp_buf].filetype = entry.ft
            end)
          end
          vim.cmd("tabnew")
          api.nvim_set_current_buf(temp_buf)
        end
      end,
    },
  })
end

return {
  {
    "ibhagwan/fzf-lua",
    enabled = false,
    dependencies = {
      "echasnovski/mini.icons",
    },
    cmd = { "FzfLua" },
    opts = function(_, opts)
      local fzf_lua_jump_action = keymap_utils.fzf_lua_jump_action
      return vim.tbl_deep_extend("force", opts or {}, {
        winopts = {
          border = "solid",
          width = 0.90,
          preview = {
            border = "solid",
            default = "builtin",
            horizontal = "right:55%",
            vertical = "down:65%",
          },
        },
        files = { formatter = "path.dirname_first", git_icons = true },
        lsp = {
          code_actions = { previewer = "codeaction_native" },
        },
        actions = {
          files = {
            enter = fzf_lua_jump_action,
          },
          buffers = { enter = fzf_lua_jump_action },
        },
        previewers = {
          builtin = { snacks_image = { enabled = true, render_inline = false } },
        },
      })
    end,
    config = function(_, opts)
      require("fzf-lua").register_ui_select(function(_, items)
        local min_h, max_h = 0.15, 0.70
        local h = (#items + 4) / vim.o.lines
        if h < min_h then
          h = min_h
        elseif h > max_h then
          h = max_h
        end
        return { winopts = { height = h, width = 0.60, row = 0.40 } }
      end)
      require("fzf-lua").setup(opts)
      api.nvim_set_hl(0, "FzfLuaBorder", { link = "FzfLuaNormal" })
      api.nvim_set_hl(0, "FzfLuaTitle", { link = "FzfLuaBufName" })
      api.nvim_create_user_command("FzfLuaNotification", function()
        return fzf_notification()
      end, {})
    end,
    keys = {
      {
        "<leader>tt",
        function()
          require("fzf-lua").grep({
            search = [[\b(TODO|WIP|NOTE|XXX|INFO|DOCS|PERF|TEST|HACK|WARNING|WARN|FIX|FIXME|BUG|ERROR):]],
            no_esc = true,
            multiline = true,
          })
        end,
        desc = "Todo comments",
      },
      {
        "<Leader>a",
        function()
          require("fzf-lua").lsp_code_actions({
            silent = true,
            winopts = { preview = { horizontal = "right:65%", vertical = "down:75%" } },
          })
        end,
        remap = false,
        mode = { "n", "x" },
        desc = "Code actions",
      },
      {
        "<Leader>tf",
        function(opts)
          return require("fzf-lua").files(opts)
        end,
        remap = false,
        mode = "n",
        desc = "Fuzzy find files.",
      },
      {
        "<Leader>tb",
        "<cmd>FzfLua buffers<cr>",
        remap = false,
        mode = "n",
        desc = "Show buffers.",
      },
      {
        "<Leader>tq",
        "<cmd>FzfLua quickfix<cr>",
        remap = false,
        mode = "n",
        desc = "Show quickfix.",
      },
      {
        "<Leader>tD",
        "<cmd>FzfLua diagnostics_workspace<cr>",
        remap = false,
        mode = "n",
        desc = "Project-wise diagnostics.",
      },
      {
        "<Leader>td",
        "<cmd>FzfLua diagnostics_document<cr>",
        remap = false,
        mode = "n",
        desc = "Buffer diagnostics.",
      },
      {
        "<Leader>th",
        "<cmd>FzfLua helptags<cr>",
        remap = false,
        mode = "n",
        desc = "Find help tags.",
      },
      {
        "<Leader>tH",
        "<cmd>FzfLua highlights<cr>",
        remap = false,
        mode = "n",
        desc = "Find highlight groups.",
      },
      {
        "R",
        "<cmd>FzfLua grep_project<cr>",
        remap = false,
        mode = "n",
        desc = "Live grep.",
      },
      {
        "<Leader>f",
        "<cmd>FzfLua grep_curbuf<cr>",
        remap = false,
        mode = "n",
        desc = "Fuzzy find current buffer.",
      },
      {
        "<Leader>tr",
        "<cmd>FzfLua resume<cr>",
        remap = false,
        mode = "n",
        desc = "Resume last fzf-lua session",
      },
      {
        "<Space>df",
        "<cmd>FzfLua dap_frames<cr>",
        remap = false,
        mode = "n",
        desc = "[D]ap [f]rames",
      },
      {
        "<Space>dc",
        "<cmd>FzfLua dap_commands<cr>",
        remap = false,
        mode = "n",
        desc = "[D]ap [c]ommands",
      },
      {
        "<Space>dv",
        "<cmd>FzfLua dap_variables<cr>",
        remap = false,
        mode = "n",
        desc = "[D]ap [v]ariables",
      },
      {
        "<Space>db",
        "<cmd>FzfLua dap_breakpoints<cr>",
        remap = false,
        mode = "n",
        desc = "[D]ap [b]reakpoints",
      },
      {
        "<Space>dc",
        "<cmd>FzfLua dap_configurations<cr>",
        remap = false,
        mode = "n",
        desc = "[D]ap [c]onfigurations",
      },
    },
  },
  { "nvim-telescope/telescope.nvim", enabled = false },
}
