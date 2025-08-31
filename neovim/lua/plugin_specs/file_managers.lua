return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    version = "*",
    dependencies = {
      "3rd/image.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-lua/plenary.nvim",
    },
    init = function()
      vim.api.nvim_create_autocmd("BufEnter", {
        -- make a group to be able to delete it later
        group = vim.api.nvim_create_augroup("NeoTreeInit", { clear = true }),
        callback = function()
          local f = vim.fn.expand("%:p")
          if vim.fn.isdirectory(f) ~= 0 then
            vim.cmd("Neotree action=focus dir=" .. f)
            -- neo-tree is loaded now, delete the init autocmd
            vim.api.nvim_clear_autocmds({ group = "NeoTreeInit" })
          end
        end,
      })
    end,
    opts = function(_, opts)
      local function on_move(data)
        require("snacks").rename.on_rename_file(data.source, data.destination)
      end
      local events = require("neo-tree.events")
      opts = vim.tbl_deep_extend("force", opts, {
        close_if_last_window = true,
        sort_case_insensitive = true,
        use_libuv_file_watcher = true,
        event_handlers = {
          { event = events.FILE_MOVED, handler = on_move },
          { event = events.FILE_RENAMED, handler = on_move },
        },
        filesystem = {
          filtered_items = {
            visible = true,
            hide_hidden = false,
            hide_dotfiles = false,
          },
          follow_current_file = { enabled = true },
        },
        window = {
          mappings = {
            ["<cr>"] = "open",
            ["<left>"] = "navigate_up",
            ["<right>"] = "set_root",
            ["<space>"] = "open",
          },
        },
        buffers = {
          follow_current_file = { enabled = true },
        },
        source_selector = { show_scrolled_off_parent_node = true },
        default_component_configs = {
          icon = { folder_closed = "", folder_open = "" },
          git_status = { symbols = { added = "", modified = "" } },
        },
      })
    end,
    keys = {
      {
        "<Leader>T",
        "<cmd>Neotree action=focus toggle<cr>",
        mode = "n",
        remap = true,
        desc = "Neo-tree",
      },
    },
    ft = { "netrw" },
    cmd = { "Neotree" },
  },
  {
    "stevearc/oil.nvim",
    version = "*",
    opts = { lsp_file_methods = { autosave_changes = true } },
    dependencies = { "nvim-mini/mini.icons" },
    cmd = { "Oil" },
  },
}
