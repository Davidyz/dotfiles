---@module "lazy"
---@type LazySpec[]
return {

  { "nmac427/guess-indent.nvim", opts = {}, event = { "FileType" } },
  {
    "mistricky/codesnap.nvim",
    build = "make",
    version = "*",
    cond = function()
      return require("_utils").no_vscode()
        and vim.fn.executable("make")
        and require("_utils").platform() ~= "win"
    end,
    config = function(_, opts)
      if vim.fn.isdirectory(opts.save_path) ~= 1 then
        vim.fn.mkdir(opts.save_path, "p")
      end
      require("codesnap").setup(opts)
    end,
    opts = {
      mac_window_bar = false,
      save_path = vim.fn.expand("~/Pictures/nvim/"),
      has_breadcrumbs = true,
      has_line_number = true,
      show_workspace = false,
      watermark = "Davidyz @ github.com",
      bg_theme = "grape",
    },
    cmd = { "CodeSnap", "CodeSnapSave", "CodeSnapASCII" },
  },
  { "mawkler/modicator.nvim", opts = {}, event = { "BufReadPost", "BufNewFile" } },
  {
    "brenoprata10/nvim-highlight-colors",
    config = function()
      require("nvim-highlight-colors").setup({
        render = "virtual",
        enable_tailwind = true,
      })
      require("nvim-highlight-colors").turnOn()
    end,
    event = { "BufReadPost", "BufNewFile" },
  },

  {
    "smoka7/hop.nvim",
    opts = {},
    keys = {
      {
        "f",
        function()
          local orig_cmdheight = vim.o.cmdheight
          vim.o.cmdheight = 1
          ---@diagnostic disable-next-line: missing-fields
          require("hop").hint_char1({
            current_line_only = false,
          })
          vim.o.cmdheight = orig_cmdheight
        end,
        remap = false,
        mode = "n",
        desc = "Hop to character.",
      },
      {
        "F",
        function()
          return require("hop-treesitter").hint_nodes()
        end,
        remap = false,
        mode = "n",
        desc = "Hop to node.",
      },
    },
  },

  {
    "tris203/precognition.nvim",
    enabled = false,
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      showBlankVirtLine = false,
      gutterHints = {
        G = { prio = 0 },
        gg = { prio = 0 },
        PrevParagraph = { prio = 0 },
        NextParagraph = { prio = 0 },
      },
    },
  },
  {
    "keaising/im-select.nvim",
    cond = function()
      return require("_utils").any(
        { "fcitx-remote", "fcitx5-remote", "im-select", "im-select.exe" },
        function(arg)
          return vim.fn.executable(arg) == 1
        end
      )
    end,
    main = "im_select",
    opts = {
      async_switch_im = false,
      set_previous_events = { "InsertEnter" },
    },
    event = { "BufReadPost", "BufNewFile" },
  },

  {
    "folke/which-key.nvim",
    event = "BufEnter",
    opts = {
      preset = "modern",
    },
    config = function(_, opts)
      local wk = require("which-key")
      wk.setup(opts)
      wk.add({
        { "<leader>c", group = "CodeCompanion" },
        { "<leader>C", group = "Coverage" },
        { "<leader>t", group = "Fzf-lua" },
        { "<leader>r", group = "Refactoring" },
        { "<leader>e", group = "Extract" },
        { "<leader>g", group = "Git integrations" },
        { "<Space>t", group = "Neotest" },
        { "<Space>d", group = "DAP pickers" },
      })
    end,
    keys = {
      {
        "<leader>?",
        function()
          require("which-key").show({ global = false })
        end,
        desc = "Buffer Local Keymaps (which-key)",
      },
    },
    cond = require("_utils").no_vscode(),
  },

  {
    "NStefan002/screenkey.nvim",
    config = true,
    cmd = "Screenkey",
    opts = {
      win_opts = {
        relative = "editor",
        anchor = "SE",
        width = 40,
        height = 3,
        border = "single",
      },
      compress_after = 3,
      clear_after = 3,
      disable = {
        filetypes = { "toggleterm" },
        buftypes = { "terminal" },
      },
    },
  },
}
