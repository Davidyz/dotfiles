return {
  {
    "ibhagwan/fzf-lua",
    dependencies = {
      "echasnovski/mini.icons",
    },
    cmd = { "FzfLua" },
    opts = function(_, opts)
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
            enter = require("keymaps.utils").fzf_lua_jump_action,
          },
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
      vim.api.nvim_set_hl(0, "FzfLuaBorder", { link = "FzfLuaNormal" })
      vim.api.nvim_set_hl(0, "FzfLuaTitle", { link = "FzfLuaBufName" })
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
