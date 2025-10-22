return {
  {
    "wintermute-cell/gitignore.nvim",
    cmd = "Gitignore",
    config = function()
      local gitignore = require("gitignore")
      gitignore.generate = function(opts)
        vim.ui.select(
          gitignore.templateNames,
          { prompt = "Select templates for gitignore file> " },
          function(item, idx)
            if item then
              gitignore.createGitignoreBuffer(opts.args, item)
            end
          end
        )
      end
      vim.api.nvim_create_user_command(
        "Gitignore",
        gitignore.generate,
        { nargs = "?", complete = "file" }
      )
    end,
  },
  {
    "f-person/git-blame.nvim",
    keys = {
      {
        "<Leader>go",
        "<cmd>GitBlameOpenCommitURL<cr><cmd>GitBlameDisable<cr>",
        noremap = true,
      },
      {
        "<Leader>gc",
        "<cmd>GitBlameCopyCommitURL<cr><cmd>GitBlameDisable<cr>",
        noremap = true,
      },
    },
    init = function()
      vim.g.gitblame_enabled = 0
    end,
  },
  {
    "sindrets/diffview.nvim",
    opts = {
      view = {
        merge_tool = { layout = "diff3_mixed" },
      },
      file_panel = { listing_style = "list" },
    },
    cmd = { "DiffviewOpen", "DiffviewFileHistory" },
  },
  {
    "lewis6991/gitsigns.nvim",
    keys = {
      {
        "<Leader>gb",
        function()
          local gitsigns = require("gitsigns")
          gitsigns.toggle_current_line_blame()
          if require("gitsigns.config").config.current_line_blame then
            vim.notify("Enabled.", "info", { title = "Git Blame" })
          else
            vim.notify("Disabled.", "info", { title = "Git Blame" })
          end
        end,
        noremap = true,
        desc = "Toggle git [b]lame.",
      },
      {
        "<Leader>ga",
        "<cmd>Gitsigns stage_hunk<cr>",
        noremap = true,
        desc = "Git [a]dd hunk.",
        mode = { "n", "x" },
      },
      {
        "<Leader>gu",
        "<cmd>Gitsigns undo_stage_hunk<cr>",
        noremap = true,
        desc = "Git [u]ndo add hunk.",
        mode = { "n", "x" },
      },
      {
        "<Leader>gr",
        "<cmd>Gitsigns reset_hunk<cr>",
        noremap = true,
        desc = "Git [r]eset hunk.",
        mode = { "n", "x" },
      },
      {
        "<Leader>gp",
        "<cmd>Gitsigns preview_hunk_inline<cr>",
        noremap = true,
        desc = "Git [p]review hunk.",
        mode = { "n", "x" },
      },
      {
        "]h",
        "<cmd>Gitsigns nav_hunk next<cr>",
        noremap = true,
        desc = "Next hunk.",
        mode = { "n" },
      },
      {
        "[h",
        "<cmd>Gitsigns nav_hunk prev<cr>",
        noremap = true,
        desc = "Previous hunk.",
        mode = { "n" },
      },
    },
    opts = {
      signs = {},
      signs_staged = {
        add = { text = "" },
        change = { text = "" },
        delete = { text = "" },
        topdelete = { text = "‾" },
        changedelete = { text = ">" },
        untracked = { text = "┆" },
      },
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = "right_align",
        delay = 10,
        ignore_whitespace = false,
        virt_text_priority = 100,
      },
      preview_config = { border = "solid" },
    },
    config = function(_, opts)
      require("gitsigns").setup(opts)
      vim.api.nvim_set_hl(0, "GitSignsCurrentLineBlame", { link = "Comment" })
    end,
    event = { "BufReadPost", "BufNewFile" },
    cmd = { "Gitsigns" },
  },
  {
    "jsongerber/thanks.nvim",
    opts = {
      star_on_install = true,
      star_on_startup = false,
      ignore_repos = {},
      ignore_authors = {},
      unstar_on_uninstall = false,
      ask_before_unstarring = false,
      ignore_unauthenticated = true,
    },
    event = { "VeryLazy" },
    cond = function()
      return require("_utils").no_vscode()
    end,
  },
}
