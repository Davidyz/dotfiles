return {
  {
    "pogyomo/winresize.nvim",
    keys = {
      {
        "<C-Left>",
        function()
          require("winresize").resize(0, 1, "left")
        end,
        mode = "n",
      },
      {
        "<C-Right>",
        function()
          require("winresize").resize(0, 1, "right")
        end,
        mode = "n",
      },
      {
        "<C-Up>",
        function()
          require("winresize").resize(0, 1, "up")
        end,
        mode = "n",
      },
      {
        "<C-Down>",
        function()
          require("winresize").resize(0, 1, "down")
        end,
        mode = "n",
      },
    },
  },
  {
    "willothy/flatten.nvim",
    opts = { window = { open = "tab" } },
    lazy = false,
    priority = 1001,
    commit = "d3e3529",
  },
  {
    "nvim-focus/focus.nvim",
    opts = {
      autoresize = { enable = false },
      ui = {
        cursorline = true,
        cursorcolumn = true,
      },
    },
    event = "winnew",
    init = function()
      local ignore_filetypes = { "neo-tree", "outline" }
      local ignore_buftypes = { "nofile", "prompt", "popup" }

      local augroup = vim.api.nvim_create_augroup("FocusDisable", { clear = true })

      vim.api.nvim_create_autocmd("WinEnter", {
        group = augroup,
        callback = function(_)
          if vim.tbl_contains(ignore_buftypes, vim.bo.buftype) then
            vim.w.focus_disable = true
          else
            vim.w.focus_disable = false
          end
        end,
        desc = "Disable focus autoresize for BufType",
      })

      vim.api.nvim_create_autocmd("FileType", {
        group = augroup,
        callback = function(_)
          if vim.tbl_contains(ignore_filetypes, vim.bo.filetype) then
            vim.b.focus_disable = true
          else
            vim.b.focus_disable = false
          end
        end,
        desc = "Disable focus autoresize for FileType",
      })
    end,
  },
}
