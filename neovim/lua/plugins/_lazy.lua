---@module "lazy"

---@diagnostic disable: missing-fields
M = {}
local utils = require("_utils")

---@type LazySpec[]
M.plugins = {
  -- NOTE: mini
  {
    "echasnovski/mini.icons",
    opts = {},
    lazy = true,
    specs = {
      { "nvim-tree/nvim-web-devicons", enabled = false, optional = true },
    },
    init = function()
      package.preload["nvim-web-devicons"] = function()
        require("mini.icons").mock_nvim_web_devicons()
        return package.loaded["nvim-web-devicons"]
      end
    end,
  },
  {
    "echasnovski/mini.test",
    version = "*",
    event = { "BufEnter tests/**/*.lua" },
    opts = {},
  },

  -- NOTE: filetypes
  {
    "r-pletnev/pdfreader.nvim",
    lazy = false,
    dependencies = {
      "folke/snacks.nvim", -- image rendering
    },
    -- config = function()
    --   require("pdfreader").setup()
    -- end,
  },
  {
    "stevearc/vim-arduino",
    ft = { "arduino" },
    cond = function()
      return vim.fn.executable("arduino-cli") ~= 0 and utils.no_vscode()
    end,
  },
  {
    "lervag/vimtex",
    ft = { "tex" },
    cond = utils.no_vscode,
    config = function()
      require("executable-checker").add_executable(
        { "zathura", "xdotool", "biber" },
        "vimtex"
      )
      vim.g.vimtex_quickfix_mode = 0
      vim.g.vimtex_syntax_enabled = 0

      if vim.fn.executable("zathura") then
        vim.g.vimtex_view_method = "zathura"
      else
        vim.g.vimtex_view_method = "general"
        vim.g.vimtex_view_general_viewer = "firefox"
      end
      vim.api.nvim_create_autocmd(
        { "BufEnter", "BufWritePost" },
        { command = "VimtexView", pattern = "*.tex" }
      )
      --vim.g.vimtex_view_general_viewer = "okular"
      --vim.g.vimtex_view_general_options = "--unique file:@pdf#src:@line@tex"
    end,
  },
  {
    "shiracamus/vim-syntax-x86-objdump-d",
    cond = function()
      return vim.fn.executable("objdump") ~= 0
    end,
  },
  {
    "neovimhaskell/haskell-vim",
    ft = { "haskell", "hs" },
    init = function()
      vim.g.haskell_enable_quantification = 1
      vim.g.haskell_enable_recursivedo = 1
      vim.g.haskell_enable_arrowsyntax = 1
      vim.g.haskell_enable_pattern_synonyms = 1
      vim.g.haskell_enable_typeroles = 1
      vim.g.haskell_enable_static_pointers = 1
      vim.g.haskell_backpack = 1
      vim.g.haskell_indent_if = 3
      vim.g.haskell_indent_case = 2
      vim.g.haskell_indent_let = 4
      vim.g.haskell_indent_where = 6
      vim.g.haskell_indent_before_where = 2
      vim.g.haskell_indent_after_bare_where = 2
      vim.g.haskell_indent_do = 3
      vim.g.haskell_indent_in = 1
      vim.g.haskell_indent_guard = 2
      vim.g.haskell_indent_case_alternative = 1
      vim.g.cabal_indent_section = 2
    end,
  },
  {
    "cameron-wags/rainbow_csv.nvim",
    config = true,
    ft = {
      "csv",
      "tsv",
      "csv_semicolon",
      "csv_whitespace",
      "csv_pipe",
      "rfc_csv",
      "rfc_semicolon",
    },
    cmd = {
      "RainbowDelim",
      "RainbowDelimSimple",
      "RainbowDelimQuoted",
      "RainbowMultiDelim",
    },
  },
  {
    "lark-parser/vim-lark-syntax",
    ft = { "lark" },
  },
  {
    "vim-scripts/cup.vim",
    ft = { "cup" },
  },
  {
    "udalov/javap-vim",
    ft = { "javap" },
  },
  {
    "cespare/vim-toml",
    branch = "main",
    ft = { "toml" },
  },
  {
    "vim-scripts/crontab.vim",
    ft = { "crontab" },
  },

  -- NOTE: markdown
  {
    "hedyhli/markdown-toc.nvim",
    ft = { "markdown" },
    opts = { headings = { before_toc = false } },
  },
  {
    "Myzel394/easytables.nvim",
    cmd = { "EasyTablesCreateNew", "EasyTablesImportThisTable" },
    opts = {},
  },
  {
    "toppair/peek.nvim",
    ft = { "markdown" },
    build = "deno task --quiet build:fast",
    opts = { theme = "dark", filetype = { "markdown", "pandoc" }, app = "firefox" },
    main = "peek",
    keys = {
      {
        "mp",
        function()
          local peek = require("peek")
          if peek.is_open() then
            peek.close()
          else
            peek.open()
          end
        end,
      },
      mode = "n",
    },
    cond = function()
      return utils.no_vscode() and vim.fn.executable("deno") ~= 0
    end,
  },

  -- color schemes.
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function(_, opts)
      require("catppuccin").setup(opts)
      vim.cmd.colorscheme("catppuccin")
      vim.api.nvim_set_hl(0, "CursorColumn", { link = "CursorLine" })
    end,
    lazy = false,
    opts = function()
      local flavour = "mocha"
      return {
        flavour = flavour,
        term_colors = true,
        custom_highlights = function(colors)
          return {
            FloatBorder = { fg = colors.mantle, bg = colors.mantle },
            FloatTitle = { fg = colors.lavender, bg = colors.mantle },
            LspInfoBorder = { fg = colors.mantle, bg = colors.mantle },
            WinSeparator = { bg = colors.base, fg = colors.lavender },
          }
        end,
        dim_inactive = { enabled = false },
        default_integrations = {
          blink_cmp = true,
          diffview = true,
          fidget = true,
          fzf = true,
          headlines = true,
          hop = true,
          lspsaga = true,
          mason = true,
          mini = { enabled = true },
          native_lsp = { enabled = true },
          navic = { enabled = true },
          neotree = true,
          nvim_surround = true,
          rainbow_delimiters = true,
          snacks = { enabled = true },
          which_key = true,
        },
      }
    end,
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    opts = function()
      vim.treesitter.language.register("markdown", "vimwiki")
      return { file_types = { "markdown", "vimwiki", "codecompanion" } }
    end,
    ft = { "markdown", "vimwiki", "codecompanion" },
    dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.icons" },
  },

  -- NOTE: tree sitter
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    config = function()
      pcall(function()
        require("nvim-dap-repl-highlights").setup()
      end)
      require("nvim-treesitter").setup()
      require("nvim-treesitter").install({ "dap_repl" })
    end,
    build = ":TSUpdate",
    cond = utils.no_vscode,
    dependencies = {
      "williamboman/mason.nvim",
      {
        "MeanderingProgrammer/treesitter-modules.nvim",
        dependencies = {
          "nvim-treesitter/nvim-treesitter",
          "Davidyz/nvim-dap-repl-highlights",
        },
        ---@module 'treesitter-modules'
        ---@return ts.mod.UserConfig
        opts = function(_, opts)
          ---@type ts.mod.UserConfig
          opts = vim.tbl_deep_extend("force", {
            ignore_install = { "csv" },
            highlight = { enable = true },
            indent = { enable = true },
            incremental_selection = {
              enable = true,
              keymaps = {
                init_selection = "<TAB>",
                node_incremental = "<TAB>",
                scope_incremental = false,
                node_decremental = "<S-TAB>",
              },
            },
          }, opts or {})
          if #vim.uv.cpu_info() >= 4 then
            opts.ensure_installed = require("plugins.utils").treesitter_parsers
          end
          return opts
        end,
      },
    },
  },
  {
    "hiphish/rainbow-delimiters.nvim",
    event = { "BufReadPost", "BufNewFile" },
    submodules = false,
    config = function()
      local rainbow_delimiters = require("rainbow-delimiters")
      vim.g.rainbow_delimiters = {
        strategy = {
          [""] = rainbow_delimiters.strategy["global"],
          vim = rainbow_delimiters.strategy["local"],
        },
        query = {
          [""] = "rainbow-delimiters",
          lua = "rainbow-blocks",
        },
        highlight = {
          "RainbowDelimiterRed",
          "RainbowDelimiterYellow",
          "RainbowDelimiterBlue",
          "RainbowDelimiterOrange",
          "RainbowDelimiterGreen",
          "RainbowDelimiterViolet",
          "RainbowDelimiterCyan",
        },
      }
      vim.api.nvim_set_hl(
        0,
        "MatchParen",
        ---@diagnostic disable-next-line: param-type-mismatch
        vim.tbl_deep_extend(
          "force",
          vim.api.nvim_get_hl(0, { name = "MatchParen" }),
          { fg = "NONE" }
        )
      )
    end,
    dependencies = { "nvim-treesitter/nvim-treesitter" },
  },
  {
    "nvim-treesitter/playground",
    cmd = "TSPlaygroundToggle",
    cond = utils.no_vscode,
  },
  {
    "windwp/nvim-autopairs",
    cond = utils.no_vscode,
    config = function()
      require("plugins.nvim_autopairs")
    end,
    event = { "InsertEnter", "CmdlineEnter" },
  },
  {
    "andymass/vim-matchup",
    event = { "BufReadPost", "BufNewFile" },
    init = function()
      vim.g.matchup_matchparen_offscreen = {
        method = "popup",
        fullwidth = 0,
        border = "solid",
        highlight = "FidgetNormal",
      }
      vim.api.nvim_create_autocmd({ "BufNewFile", "BufReadPost" }, {
        callback = function()
          vim.api.nvim_set_hl(0, "MatchWord", { bold = true, italic = true })
          vim.api.nvim_set_hl(0, "MatchupVirtualText", {
            bold = true,
            italic = true,
            fg = vim.api.nvim_get_hl(0, { name = "Comment" }).fg,
          })
        end,
      })
    end,
  },
  {
    "kevinhwang91/nvim-ufo",
    dependencies = {
      "kevinhwang91/promise-async",
      "nvim-treesitter/nvim-treesitter",
    },
    cond = utils.no_vscode,
    init = function()
      vim.o.foldenable = true
      vim.o.foldlevel = 99
      vim.o.foldlevelstart = 99
      vim.o.foldcolumn = "0"
    end,
    config = function(_, opts)
      local ufo = require("ufo")
      ufo.setup(opts)
      vim.api.nvim_set_hl(0, "UfoCursorFoldedLine", { link = "CursorLine" })
      vim.api.nvim_set_hl(0, "UfoPreviewBg", { link = "FzfLuaPreviewBorder" })
      vim.api.nvim_set_hl(0, "UfoPreviewWinBar", { link = "FzfLuaPreviewBorder" })
      vim.api.nvim_set_hl(0, "UfoFoldedBg", { link = "CursorLine" })
      vim.keymap.set("n", "P", function()
        require("ufo.preview"):peekFoldedLinesUnderCursor()
      end, { noremap = true, desc = "Peek inside fold." })
      vim.keymap.set("n", "<BS>", "za", { noremap = true, desc = "Toggle fold." })
      vim.keymap.set(
        "n",
        "[f",
        ufo.goPreviousClosedFold,
        { noremap = true, desc = "Previous fold." }
      )
      vim.keymap.set(
        "n",
        "]f",
        ufo.goNextClosedFold,
        { noremap = true, desc = "Next fold." }
      )
    end,
    opts = {
      preview = {
        win_config = { winhighlight = "Normal:FzfLuaPreviewBorder", winblend = 0 },
      },
      fold_virt_text_handler = function(virt_text, lnum, end_lnum, width, truncate)
        local result = {}
        local _end = end_lnum - 1
        local final_text =
          vim.trim(vim.api.nvim_buf_get_text(0, _end, 0, _end, -1, {})[1])
        local suffix = final_text:format(end_lnum - lnum)
        local suffix_width = vim.fn.strdisplaywidth(suffix)
        local target_width = width - suffix_width
        local cur_width = 0
        for _, chunk in ipairs(virt_text) do
          local chunk_text = chunk[1]
          local chunk_width = vim.fn.strdisplaywidth(chunk_text)
          if target_width > cur_width + chunk_width then
            table.insert(result, chunk)
          else
            chunk_text = truncate(chunk_text, target_width - cur_width)
            local hl_group = chunk[2]
            table.insert(result, { chunk_text, hl_group })
            chunk_width = vim.fn.strdisplaywidth(chunk_text)
            -- str width returned from truncate() may less than 2nd argument, need padding
            if cur_width + chunk_width < target_width then
              suffix = suffix .. (" "):rep(target_width - cur_width - chunk_width)
            end
            break
          end
          cur_width = cur_width + chunk_width
        end
        table.insert(result, { "   ", "NonText" })
        table.insert(result, { suffix, "TSPunctBracket" })
        table.insert(result, {
          ("\t\t %d"):format(end_lnum - lnum),
          "Comment",
        })
        return result
      end,
      provider_selector = function(bufnum, _, _)
        if vim.bo.bt == "nofile" then
          return ""
        end
        for _, cli in pairs(vim.lsp.get_clients({ bufnr = bufnum })) do
          if cli.server_capabilities.foldingRangeProvider then
            return { "lsp", "treesitter" }
          end
        end
        return { "treesitter", "indent" }
      end,
    },
    event = { "LspAttach" },
  },
  {
    "rachartier/tiny-inline-diagnostic.nvim",
    event = { "LspAttach" },
    dependencies = { "neovim/nvim-lspconfig" },
    init = function()
      vim.diagnostic.config({
        virtual_text = false,
      })
    end,
    main = "tiny-inline-diagnostic",
    cond = utils.no_vscode,
    opts = {
      preset = "nonerdfont",
      options = {
        multiple_diag_under_cursor = true,
        show_source = true,
      },
    },
  },

  -- NOTE: mason
  {
    "williamboman/mason.nvim",
    version = "*",
    init = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "mason",
        callback = function()
          vim.o.cursorline = false
        end,
      })
      require("executable-checker").add_executable({ "python3", "npm" }, "mason")
    end,
    opts = {
      ui = { height = 0.8, border = "solid" },
      max_concurrent_jobs = math.min(4, utils.cpu_count()),
      PATH = "append",
    },
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    cmd = { "MasonToolsInstall", "MasonToolsUpdate", "MasonToolsClean" },
    config = function()
      require("plugins.mason_tools")
    end,
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      { "zapling/mason-conform.nvim", opts = { ignore_install = { "black" } } },
    },
  },
  {
    "stevearc/conform.nvim",
    version = "*",
    opts = function(_, opts)
      opts = vim.tbl_deep_extend("force", opts or {}, {
        formatters_by_ft = {
          lua = { "stylua" },
          sh = { "shfmt" },
          zsh = { "shfmt" },
          bash = { "shfmt" },
          json = { "jq" },
          python = {},
          c = { "clang-format" },
          cpp = { "clang-format" },
        },
      })
      if vim.fn.executable("black") == 1 then
        vim.list_extend(opts.formatters_by_ft.python, { "black" })
      end
      return opts
    end,
    config = function(_, opts)
      require("conform").setup(opts)
      vim.api.nvim_create_autocmd("BufWritePre", {
        callback = function()
          if vim.g.format_on_save == false then
            return
          end
          require("conform").format({ lsp_format = "first" })
        end,
      })
    end,
    event = { "BufReadPost", "BufNewFile" },
  },
  {
    "mfussenegger/nvim-lint",
    config = function()
      local lint = require("lint")
      lint.linters_by_ft = {
        ["*"] = { "editorconfig-checker" },
        cmake = { "cmakelang" },
        sh = { "shellcheck" },
        bash = { "shellcheck" },
        zsh = { "shellcheck" },
        ["yaml.ghaction"] = { "actionlint" },
        lua = { "selene" },
      }
      vim.api.nvim_create_autocmd({
        "BufReadPost",
        "BufWritePost",
        "InsertEnter",
        "InsertLeave",
        "TextChanged",
        "TextChangedI",
        "CursorMoved",
        "CursorMovedI",
      }, {
        callback = function()
          if vim.bo.filetype ~= "lua" or (vim.fs.root(0, { "selene.toml" }) ~= nil) then
            lint.try_lint()
          end
        end,
      })
    end,
    dependencies = { "williamboman/mason.nvim" },
    event = { "BufReadPost", "BufNewFile" },
  },
  {
    "rshkarin/mason-nvim-lint",
    dependencies = { "williamboman/mason.nvim", "mfussenegger/nvim-lint" },
    event = { "BufReadPost", "BufNewFile" },
  },

  -- NOTE: lsp
  {
    "neovim/nvim-lspconfig",
    version = "*",
    config = function()
      require("plugins._lsp")
      require("keymaps._lsp")
      require("lspconfig.ui.windows").default_options.border = { " " }
    end,
    event = { "BufReadPre", "BufNewFile", "CmdlineEnter" },
    cond = utils.no_vscode,
    dependencies = {
      "williamboman/mason.nvim",
    },
  },
  {
    "williamboman/mason-lspconfig.nvim",
    version = "*",
    cond = utils.no_vscode,
    dependencies = { "neovim/nvim-lspconfig", "williamboman/mason.nvim" },
  },
  {
    "saghen/blink.cmp",
    build = "cargo build --release",
    dependencies = {
      "rafamadriz/friendly-snippets",
      "milanglacier/minuet-ai.nvim",
      "folke/lazydev.nvim",
      "moyiz/blink-emoji.nvim",
      {
        "Kaiser-Yang/blink-cmp-dictionary",
        dependencies = { "nvim-lua/plenary.nvim" },
      },
      {
        "saghen/blink.compat",
        version = "*",
      },
    },
    event = { "InsertEnter", "CmdlineEnter" },
    version = "*",
    opts = require("plugins.blink_cmp"),
    cond = utils.no_vscode,
  },
  {
    "xzbdmw/colorful-menu.nvim",
    opts = { max_width = 0.3 },
  },
  {
    "Davidyz/VectorCode",
    -- dir = "~/git/VectorCode/",
    version = "*",
    -- build = "uv tool upgrade vectorcode",
    build = function(plugin)
      if vim.fn.executable("uv") ~= 1 then
        return vim.notify(
          "Failed to install VectorCode because `uv` is missing.",
          vim.log.levels.WARN
        )
      end
      local stdpath = vim.fn.stdpath("data")
      if string.find(plugin.dir, stdpath) then
        local command
        if vim.fn.executable("vectorcode") == 1 then
          command = "uv tool upgrade vectorcode"
        else
          command = 'uv tool install "vectorcode[lsp,mcp]"'
        end
        vim.system(vim.split(command, " ", { trimempty = true }), {}, nil)
      end
    end,
    opts = function()
      return {
        async_backend = "lsp",
        notify = true,
        on_setup = { lsp = true },
        n_query = 10,
        timeout_ms = -1,
        async_opts = {
          events = { "BufWritePost" },
          single_job = true,
          query_cb = require("vectorcode.utils").make_surrounding_lines_cb(40),
          debounce = -1,
          n_query = 30,
        },
      }
    end,
    config = function(_, opts)
      vim.lsp.config("vectorcode_server", {
        cmd_env = {
          HTTP_PROXY = os.getenv("HTTP_PROXY"),
          HTTPS_PROXY = os.getenv("HTTPS_PROXY"),
        },
      })
      require("vectorcode").setup(opts)
      -- vim.api.nvim_create_autocmd("LspAttach", {
      --   callback = function()
      --     require("vectorcode.config").get_cacher_backend().register_buffer(0)
      --   end,
      -- })
    end,
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    cmd = "VectorCode",
    cond = function()
      return vim.fn.executable("vectorcode") == 1 and utils.no_vscode()
    end,
  },
  {
    "ravitemer/mcphub.nvim",
    version = "*",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    build = "bundled_build.lua",
    cmd = { "MCPHub" },
    opts = function()
      return {
        port = 3000,
        use_bundled_binary = true,
      }
    end,
  },
  {
    "milanglacier/minuet-ai.nvim",
    cond = utils.no_vscode,
    event = "VeryLazy",
    config = function(_, opts)
      local num_docs = 10
      opts = {
        add_single_line_entry = true,
        n_completions = 1,
        after_cursor_filter_length = 0,
        provider = "gemini",
        provider_options = {
          gemini = {
            model = "gemini-2.0-flash",
            chat_input = {
              template = "{{{language}}}\n{{{tab}}}\n{{{repo_context}}}{{{git_diff}}}<|fim_prefix|>{{{context_before_cursor}}}<|fim_suffix|>{{{context_after_cursor}}}<|fim_middle|>",
              repo_context = function()
                local has_vc, vectorcode_config = pcall(require, "vectorcode.config")
                if has_vc then
                  return vectorcode_config
                    .get_cacher_backend()
                    .make_prompt_component(0, function(file)
                      return "<|file_separator|>" .. file.path .. "\n" .. file.document
                    end).content
                else
                  return ""
                end
              end,
              git_diff = function()
                if vim.bo.filetype == "gitcommit" then
                  local git_diff_job = vim.system(
                    { "git", "diff", "--cached" },
                    {},
                    nil
                  )
                  local recent_commits_job = vim.system(
                    { "git", "log", "HEAD~10..HEAD", "--" },
                    {},
                    nil
                  )
                  local curr_branch_job = vim.system(
                    { "git", "branch", "--show-current" },
                    {},
                    nil
                  )
                  local git_diff = vim.trim(git_diff_job:wait().stdout)
                  local curr_branch = vim.trim(curr_branch_job:wait().stdout)
                  if git_diff then
                    local recent_commits = recent_commits_job:wait().stdout

                    local prompt = ""
                    if curr_branch then
                      prompt =
                        string.format("The current branch name is `%s`\n", curr_branch)
                    end
                    if recent_commits then
                      prompt = prompt
                        .. string.format(
                          "The following are the most recent 10 commits in the repo:\n%s\nFollow their style of writing.\n",
                          recent_commits
                        )
                    end
                    prompt = prompt
                      .. "Write a concise conventional commit message for the following git diff: "
                      .. git_diff
                    return prompt
                  end
                end
                return ""
              end,
            },
            optional = {
              generationConfig = { stop_sequences = { "<|file_separator|>" } },
            },
          },
        },
        request_timeout = 10,
      }
      local num_ctx = 1024 * 32
      local job = require("plenary.job"):new({
        command = "curl",
        args = { os.getenv("OLLAMA_HOST"), "--connect-timeout", "1" },
        on_exit = function(self, code, signal)
          if code == 0 then
            opts.provider_options.openai_fim_compatible = {
              api_key = "TERM",
              name = "Ollama",
              stream = false,
              end_point = os.getenv("OLLAMA_HOST") .. "/v1/completions",
              model = os.getenv("OLLAMA_CODE_MODEL"),
              optional = {
                max_tokens = 256,
                num_ctx = num_ctx,
              },
              template = {
                prompt = function(pref, suff)
                  if vim.bo.filetype == "gitcommit" then
                    local git_diff =
                      vim.system({ "git", "diff" }, {}, nil):wait().stdout
                    if git_diff then
                      return "You are a experienced software developer, writing a conventional git commit message for the following patch.<|file_sep|>"
                        .. git_diff
                        .. "<|fim_middle|>"
                    end
                  end
                  local prompt_message = ([[Perform fill-in-middle from the following snippet of a %s code. Respond with only the filled in code.]]):format(
                    vim.bo.filetype
                  )
                  local has_vc, vectorcode_config = pcall(require, "vectorcode.config")
                  if has_vc then
                    local cache_result =
                      vectorcode_config.get_cacher_backend().make_prompt_component(0)
                    num_docs = cache_result.count
                    prompt_message = prompt_message .. cache_result.content
                  end

                  return prompt_message
                    .. "<|fim_prefix|>"
                    .. pref
                    .. "<|fim_suffix|>"
                    .. suff
                    .. "<|fim_middle|>"
                end,
                suffix = false,
              },
            }
          end
          vim.schedule(function()
            require("minuet").setup(opts)
            local openai_fim_compatible =
              require("minuet.backends.openai_fim_compatible")
            local orig_get_text_fn = openai_fim_compatible.get_text_fn
            openai_fim_compatible.get_text_fn = function(json)
              local bufnr = vim.api.nvim_get_current_buf()
              local co = coroutine.create(function()
                vim.b[bufnr].ai_raw_response = json
                local has_vc, vectorcode_config = pcall(require, "vectorcode.config")
                if not has_vc then
                  return
                end
                if vectorcode_config.get_cacher_backend().buf_is_registered() then
                  local new_num_query = num_docs
                  if json.usage.total_tokens > num_ctx then
                    new_num_query = math.max(num_docs - 1, 1)
                  elseif json.usage.total_tokens < num_ctx * 0.9 then
                    new_num_query = num_docs + 1
                  end
                  vectorcode_config
                    .get_cacher_backend()
                    .register_buffer(0, { n_query = new_num_query })
                end
              end)
              coroutine.resume(co)
              return orig_get_text_fn(json)
            end
          end)
        end,
      })
      job:start()
    end,
    dependencies = { "ibhagwan/fzf-lua" },
  },
  {
    "Davidyz/codicons.nvim",
    branch = "cmp-integration",
    opts = {},
    config = true,
    event = { "InsertEnter" },
    cond = utils.no_vscode,
  },
  {
    "garymjr/nvim-snippets",
    -- custom snippets by filetypes at ~/.config/nvim/snippets/
    event = { "InsertEnter" },
    opts = {
      friendly_snippets = true,
      create_autocmd = true,
      create_cmp_source = false,
    },
    dependencies = { "rafamadriz/friendly-snippets" },
    cond = utils.no_vscode,
  },
  {
    "SmiteshP/nvim-navic",
    opts = {
      lsp = { auto_attach = true },
      icons = require("_utils").codicons,
    },
    event = "LspAttach",
    cond = utils.no_vscode,
  },
  {
    "Wansmer/symbol-usage.nvim",
    event = "LspAttach",
    opts = function()
      local function h(name)
        return vim.api.nvim_get_hl(0, { name = name })
      end

      -- hl-groups can have any name
      vim.api.nvim_set_hl(
        0,
        "SymbolUsageRounding",
        { fg = h("CursorLine").bg, italic = true }
      )
      vim.api.nvim_set_hl(
        0,
        "SymbolUsageContent",
        { bg = h("CursorLine").bg, fg = h("Comment").fg, italic = true }
      )
      vim.api.nvim_set_hl(
        0,
        "SymbolUsageRef",
        { fg = h("Function").fg, bg = h("CursorLine").bg, italic = true }
      )
      vim.api.nvim_set_hl(
        0,
        "SymbolUsageDef",
        { fg = h("Type").fg, bg = h("CursorLine").bg, italic = true }
      )
      vim.api.nvim_set_hl(
        0,
        "SymbolUsageImpl",
        { fg = h("@keyword").fg, bg = h("CursorLine").bg, italic = true }
      )

      local function text_format(symbol)
        local res = {}

        local round_start = { "", "SymbolUsageRounding" }
        local round_end = { "", "SymbolUsageRounding" }

        -- Indicator that shows if there are any other symbols in the same line
        local stacked_functions_content = symbol.stacked_count > 0
            and ("+%s"):format(symbol.stacked_count)
          or ""

        if symbol.references then
          local usage = symbol.references <= 1 and "usage" or "usages"
          local num = symbol.references == 0 and "no" or symbol.references
          table.insert(res, round_start)
          table.insert(res, { "󰌹  ", "SymbolUsageRef" })
          table.insert(res, { ("%s %s"):format(num, usage), "SymbolUsageContent" })
          table.insert(res, round_end)
        end

        if symbol.definition then
          if #res > 0 then
            table.insert(res, { " ", "NonText" })
          end
          table.insert(res, round_start)
          table.insert(res, { "󰳽  ", "SymbolUsageDef" })
          table.insert(res, { symbol.definition .. " defs", "SymbolUsageContent" })
          table.insert(res, round_end)
        end

        if symbol.implementation then
          if #res > 0 then
            table.insert(res, { " ", "NonText" })
          end
          table.insert(res, round_start)
          table.insert(res, { "󰡱  ", "SymbolUsageImpl" })
          table.insert(res, { symbol.implementation .. " impls", "SymbolUsageContent" })
          table.insert(res, round_end)
        end

        if stacked_functions_content ~= "" then
          if #res > 0 then
            table.insert(res, { " ", "NonText" })
          end
          table.insert(res, round_start)
          table.insert(res, { "  ", "SymbolUsageImpl" })
          table.insert(res, { stacked_functions_content, "SymbolUsageContent" })
          table.insert(res, round_end)
        end

        return res
      end
      ---@module "symbol-usage"
      ---@type UserOpts
      return {
        text_format = text_format,
        definition = { enabled = true },
        implementation = { enabled = true },
        symbol_filter = function(ctx)
          return function(symbol)
            if ctx.method == vim.lsp.protocol.Methods.textDocument_references then
              return string.find(symbol.uri, "tests") == nil
            else
              return true
            end
          end
        end,
      }
    end,
  },
  {
    "j-hui/fidget.nvim",
    event = "LspAttach",
    version = "*",
    opts = function()
      return {
        notification = {
          window = {
            normal_hl = "FidgetNormal",
            winblend = 50,
            align = "bottom",
            x_padding = 0,
            border = "solid",
          },
          view = { stack_upwards = false },
        },
      }
    end,
    config = function(_, opts)
      require("fidget").setup(opts)
      local comment_hl = vim.api.nvim_get_hl(0, { name = "Comment" })
      local float_border = vim.api.nvim_get_hl(0, { name = "FloatBorder" })
      vim.api.nvim_set_hl(
        0,
        "FidgetNormal",
        { fg = comment_hl.fg, guifg = comment_hl.guifg, bg = float_border.bg }
      )
    end,
    cond = utils.no_vscode,
  },
  {
    "ThePrimeagen/refactoring.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "ibhagwan/fzf-lua",
    },
    cond = utils.no_vscode,
    config = function()
      require("refactoring").setup({
        show_success_message = true,
        prompt_func_return_type = {
          go = false,
          java = false,
          cpp = false,
          c = false,
          h = false,
          hpp = false,
          cxx = false,
        },
        prompt_func_param_type = {
          go = false,
          java = false,
          cpp = false,
          c = false,
          h = false,
          hpp = false,
          cxx = false,
        },
        printf_statements = {},
        print_var_statements = {},
      })
    end,
    keys = {
      {
        "<leader>ef",
        function()
          return require("refactoring").refactor("Extract Function")
        end,
        desc = "Extract Function",
        noremap = true,
        expr = true,
        mode = { "x" },
      },
      {
        "<leader>ev",
        function()
          return require("refactoring").refactor("Extract Variable")
        end,
        desc = "Extract Variable",
        noremap = true,
        expr = true,
        mode = { "x" },
      },
      {
        "<leader>if",
        function()
          return require("refactoring").refactor("Inline Function")
        end,
        desc = "Inline Function",
        noremap = true,
        expr = true,
        mode = { "x" },
      },
      {
        "<leader>iv",
        function()
          return require("refactoring").refactor("Inline Variable")
        end,
        desc = "Inline Variable",
        noremap = true,
        expr = true,
        mode = { "x" },
      },
      {
        "<leader>eb",
        function()
          return require("refactoring").refactor("Extract Block")
        end,
        desc = "Extract block",
        noremap = true,
        expr = true,
        mode = { "n" },
      },
      {
        "<leader>ebf",
        function()
          return require("refactoring").refactor("Extract Block To File")
        end,
        desc = "Extract block to file",
        noremap = true,
        expr = true,
        mode = { "n" },
      },
      {
        "<leader>rp",
        function()
          return require("refactoring").debug.print_var({})
        end,
        mode = { "n" },
        expr = true,
        desc = "Add debug print statement.",
      },
      {
        "<leader>rc",
        function()
          return require("refactoring").debug.cleanup({})
        end,
        mode = { "n" },
        expr = true,
        desc = "Clear debug print statement.",
      },
      {
        "<leader>rr",
        function()
          require("refactoring").select_refactor({ prefer_ex_cmd = true })
        end,
        mode = { "n", "x" },
        desc = "Select refactoring.",
      },
    },
  },
  {
    "hedyhli/outline.nvim",
    cond = utils.no_vscode,
    cmd = { "Outline", "OutlineOpen" },
    keys = {
      { "<leader>o", ":Outline<CR>", desc = "Toggle outline" },
    },
    opts = function()
      local opts = { symbols = { icons = {} } }
      for k, v in pairs(require("_utils").codicons) do
        opts.symbols.icons[k] = { icon = v }
      end
      return opts
    end,
    init = function()
      vim.api.nvim_create_autocmd("BufEnter", {
        nested = true,
        callback = function()
          if #vim.api.nvim_list_wins() == 1 and vim.bo.filetype == "Outline" then
            vim.cmd("quit")
          end
        end,
      })
    end,
  },
  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        { path = "luvit-meta/library", words = { "vim%.uv" } },
        { path = "wezterm-types", mods = { "wezterm" } },
        { path = "folke/snacks.nvim", words = { "Snacks" } },
        {
          path = "nvim-lua/plenary.nvim",
          words = {
            "describe",
            "it",
            "pending",
            "before_each",
            "after_each",
            "clear",
            "assert.*",
          },
        },
      },
    },
    config = function(_, opts)
      require("lazydev").setup(opts)
      require("lazydev.lsp").supports = function(client)
        return client and vim.tbl_contains({ "lua_ls", "emmylua_ls" }, client.name)
      end
    end,
    dependencies = {
      { "Bilal2453/luvit-meta" },
      { "justinsgithub/wezterm-types" },
      { "folke/snacks.nvim" },
    },
  },

  {
    "linux-cultist/venv-selector.nvim",
    branch = "regexp",
    dependencies = { "neovim/nvim-lspconfig", "ibhagwan/fzf-lua" },
    ft = { "python" },
    cmd = { "VenvSelect", "VenvSelectCurrent" },
    opts = function()
      return {
        settings = {
          options = {
            activate_venv_in_terminal = true,
            cached_venv_automatic_activation = true,
            notify_user_on_venv_activation = true,
            picker = "fzf-lua",
          },
        },
      }
    end,
    config = function(_, opts)
      require("venv-selector").setup(opts)
      vim.api.nvim_create_autocmd("VimEnter", {
        desc = "Auto select virtualenv Nvim open",
        pattern = "*",
        callback = function()
          local venv = vim.fn.findfile("pyproject.toml", vim.fn.getcwd() .. ";")
          if venv ~= "" then
            pcall(require("venv-selector").retrieve_from_cache)
          end
        end,
        once = true,
      })
    end,
  },
  {
    "Davidyz/inlayhint-filler.nvim",
    keys = {
      {
        "<Leader>I",
        function()
          require("inlayhint-filler").fill()
        end,
        mode = { "n", "v" },
        desc = "Insert inlay hint to the buffer",
      },
    },
  },

  -- NOTE: dap
  {
    "mfussenegger/nvim-dap",
    cond = utils.no_vscode,
    config = function()
      require("plugins.dap")
    end,
    keys = {
      { "<F5>", "<cmd>DapContinue<CR>", desc = "DAP Continue." },
      { "<Space>o", "<cmd>DapStepOver<CR>", desc = "DAP Step [O]ver.", noremap = true },
      { "<Space>i", "<cmd>DapStepInto<CR>", desc = "DAP Step [I]nto.", noremap = true },
      { "<Space>q", "<cmd>DapStepOut<CR>", desc = "DAP Step Out.", noremap = true },
      {
        "<Space>s",
        function()
          local widgets = require("dap.ui.widgets")
          local float = widgets.centered_float(widgets.scopes, { border = "solid" })
          vim.keymap.set("n", "q", "<cmd>q<cr>", { noremap = true, buffer = float.buf })
          vim.keymap.set(
            "n",
            "<Space>s",
            "<cmd>q<cr>",
            { noremap = true, buffer = float.buf }
          )
        end,
        desc = "DAP [s]cope",
        noremap = true,
      },
      {
        "<Space>b",
        function()
          local bp = require("dap.breakpoints").get()[vim.api.nvim_get_current_buf()]
          local cursor_pos = vim.api.nvim_win_get_cursor(0)
          if
            vim.iter(bp or {}):any(function(item)
              return item.line == cursor_pos[1]
            end)
          then
            require("dap").toggle_breakpoint()
          else
            vim.ui.input({ prompt = "Breakpoint Condition?" }, function(value)
              if value then
                if value == "" then
                  value = nil
                end
                require("dap").toggle_breakpoint(value)
              end
            end)
          end
        end,
        desc = "DAP Toggle [B]reakpoint.",
        noremap = true,
      },
      {
        "<leader>d",
        function()
          require("dapui").toggle()
        end,
        desc = "Toggle DAP UI.",
      },
    },
    cmd = {
      "DapShowLog",
      "DapContinue",
      "DapToggleBreakpoint",
      "DapToggleRepl",
      "DapStepOver",
      "DapStepInto",
      "DapStepOut",
      "DapTerminate",
      "DapLoadLaunchJSON",
      "DapRestartFrame",
      "DapInstall",
      "DapUninstall",
    },
    dependencies = {
      {
        "theHamsta/nvim-dap-virtual-text",
        opts = { only_first_definition = false },
        cond = utils.no_vscode,
      },
      {
        "rcarriga/nvim-dap-ui",
        cond = utils.no_vscode,
        dependencies = { "nvim-neotest/nvim-nio" },
        key = {},
      },
      {
        "jay-babu/mason-nvim-dap.nvim",
        cond = utils.no_vscode,
      },
      {
        "mfussenegger/nvim-dap-python",
        config = function(_, opts)
          local python_test_runner = "unittest"
          if vim.fn.executable("pytest") == 1 then
            python_test_runner = "pytest"
          end
          require("dap-python").setup(
            require("venv-selector").python() or "python3",
            opts
          )
          require("dap-python").test_runner = python_test_runner
        end,
      },
    },
  },
  {
    "HiPhish/debugpy.nvim",
    cmd = { "Debugpy" },
    cond = function()
      return utils.no_vscode()
    end,
    dependencies = { "mfussenegger/nvim-dap" },
  },
  {
    "Davidyz/coredumpy.nvim",
    cmd = { "Coredumpy" },
    opts = function()
      return { python = nil }
    end,
    cond = function()
      return utils.no_vscode()
    end,
  },

  -- NOTE: misc
  {
    "folke/snacks.nvim",
    submodules = false,
    priority = 1000,
    lazy = false,
    version = "*",
    opts = function()
      return {
        bigfile = { enabled = true },
        dashboard = {
          enabled = true,
          pane_gap = 4,
          sections = {
            { section = "header" },
            { section = "keys", gap = 0, padding = 2 },
            {
              icon = " ",
              title = "Recent Files",
              section = "recent_files",
              indent = 2,
              padding = 2,
              cwd = true,
              file = vim.fn.fnamemodify(".", ":~"),
            },
            {
              icon = " ",
              title = "Projects",
              section = "projects",
              indent = 2,
              enabled = require("snacks").git.get_root() == nil,
              padding = 2,
            },
            {
              pane = 2,
              icon = " ",
              title = "Git Status",
              section = "terminal",
              enabled = require("snacks").git.get_root() ~= nil,
              cmd = "git status --short --branch --renames",
              height = 5,
              padding = 1,
              ttl = 5 * 60,
              indent = 3,
            },
            { section = "startup" },
          },
          preset = {
            keys = {
              {
                icon = " ",
                key = "f",
                desc = "Find File",
                action = ":lua Snacks.dashboard.pick('files')",
              },
              {
                icon = " ",
                key = "n",
                desc = "New File",
                action = ":ene | startinsert",
              },
              {
                icon = " ",
                key = "g",
                desc = "Find Text",
                action = ":lua Snacks.dashboard.pick('live_grep')",
              },
              {
                icon = " ",
                key = "r",
                desc = "Recent Files",
                action = ":lua Snacks.dashboard.pick('oldfiles')",
              },
              {
                icon = " ",
                key = "c",
                desc = "Config",
                action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})",
              },
              {
                icon = " ",
                key = "s",
                desc = "Restore Session",
                section = "session",
              },
              {
                icon = "󰒲 ",
                key = "L",
                desc = "Lazy",
                action = ":Lazy",
                enabled = package.loaded.lazy ~= nil,
              },
              { icon = " ", key = "q", desc = "Quit", action = ":q" },
            },
          },
        },
        image = { enabled = true },
        input = { enabled = true },
        notifier = { enabled = true },
        picker = { enabled = true },
        profiler = {
          enabled = true,
        },
        quickfile = { enabled = true },
        rename = { enabled = true },
        statuscolumn = {
          enabled = true,
          left = { "mark", "sign", "git" },
          right = { "fold" },
        },
        words = { enabled = true },
        -- scroll = { animate = { easing = "inOutCirc" } },
        styles = { input = { relative = "cursor", row = -3, col = 0 } },
      }
    end,
    init = function()
      local snacks = require("snacks")
      vim.api.nvim_create_autocmd("User", {
        pattern = "VeryLazy",
        callback = function()
          _G.dd = function(...)
            snacks.debug.inspect(...)
          end

          _G.dt = function(...)
            snacks.debug.backtrace(...)
          end
          vim.print = _G.dd
          -- vim.ui.input = Snacks.input.input
          vim.o.laststatus = 3
          vim.o.showtabline = 2
        end,
      })
    end,
    keys = {
      {
        "<Leader>p",
        function()
          local snacks = require("snacks")
          if snacks.profiler.running() then
            snacks.profiler.stop()
          else
            snacks.profiler.start()
          end
        end,
        desc = "Debug profiler",
      },
      {
        "]r",
        function()
          require("snacks").words.jump(vim.v.count1)
        end,
        desc = "Next Reference",
        mode = { "n", "t" },
      },
      {
        "[r",
        function()
          require("snacks").words.jump(-vim.v.count1)
        end,
        desc = "Prev Reference",
        mode = { "n", "t" },
      },
    },
  },
  { "nmac427/guess-indent.nvim", opts = {}, event = { "BufReadPost", "BufNewFile" } },
  {
    "mistricky/codesnap.nvim",
    build = "make",
    version = "*",
    cond = function()
      return utils.no_vscode()
        and vim.fn.executable("make")
        and utils.platform() ~= "win"
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
  {
    "folke/todo-comments.nvim",
    config = true,
    keys = {
      {
        "<Leader>tt",
        "<cmd>TodoFzfLua<CR>",
        mode = "n",
        desc = "[T]odo Comments.",
      },
      {
        "]t",
        function()
          require("todo-comments").jump_next()
        end,
        desc = "Next todo comment.",
      },
      {
        "[t",
        function()
          require("todo-comments").jump_prev()
        end,
        desc = "Previous todo comment.",
      },
    },
    event = { "BufReadPost", "BufNewFile" },
  },
  {
    "kawre/leetcode.nvim",
    cmd = "Leet",
    config = function()
      local lc = require("leetcode")
      local python_imports = {
        "# pyright: reportWildcardImportFromLibrary=false",
        "# pyright: reportUnusedClass=false",
        "# pyright: reportUnusedFunction=false",
        "# pyright: reportUnusedVariable=false",
      }
      local default_python_imports = require("leetcode.config.imports").python3
      for i, v in ipairs(default_python_imports) do
        if string.find(v, "import") ~= nil then
          default_python_imports[i] = v .. " # noqa: F401,F403"
        end
      end
      vim.list_extend(python_imports, default_python_imports)
      lc.setup({
        lang = "python3",
        injector = {
          ["python3"] = { before = python_imports },
        },
      })
    end,
    dependencies = {
      "ibhagwan/fzf-lua",
      "MunifTanjim/nui.nvim",

      -- optional
      "nvim-treesitter/nvim-treesitter",

      "echasnovski/mini.icons",
    },
  },
  {
    "Zeioth/compiler.nvim",
    cmd = { "CompilerOpen", "CompilerToggleResults", "CompilerRedo" },
    keys = {
      {
        "<F6>",
        "<cmd>CompilerOpen<CR>",
        noremap = true,
        mode = { "n" },
        silent = true,
      },
      {
        "<S-F6>",
        "<cmd>CompilerStop<CR><cmd>CompilerRedo<CR>",
        noremap = true,
        mode = { "n" },
        silent = true,
      },
      {
        "<S-F7>",
        "<cmd>CompilerToggleResults<cr>",
        noremap = true,
        mode = { "n" },
        silent = true,
      },
    },
    dependencies = {
      {
        "stevearc/overseer.nvim",
        cmd = { "CompilerOpen", "CompilerToggleResults", "CompilerRedo" },
        opts = {
          task_list = {
            direction = "bottom",
            min_height = 25,
            max_height = 25,
            default_detail = 1,
            bindings = {
              ["<C-h>"] = nil,
              ["<C-j>"] = nil,
              ["<C-k>"] = nil,
              ["<C-l>"] = nil,
            },
          },
        },
      },
    },
    opts = {},
  },
  { "mawkler/modicator.nvim", opts = {}, event = { "BufReadPost", "BufNewFile" } },
  {
    "NStefan002/2048.nvim",
    cmd = "Play2048",
    config = true,
    opts = {
      keys = {
        up = "<Up>",
        down = "<Down>",
        left = "<Left>",
        right = "<Right>",
        undo = "<C-z>",
      },
    },
  },
  { "rktjmp/playtime.nvim", cmd = { "Playtime" }, opts = { fps = 60 } },
  {
    "lewis6991/hover.nvim",
    opts = {
      init = function()
        require("hover.providers.lsp")
        require("hover.providers.man")
        require("hover.providers.dap")
        require("hover.providers.diagnostic")

        local peek_supported_capabilities = {
          vim.lsp.protocol.Methods.textDocument_implementation,
          vim.lsp.protocol.Methods.textDocument_definition,
        }
        require("hover").register({
          name = "LSP Peek",
          enabled = function(bufnr)
            return vim.iter(vim.lsp.get_clients({ bufnr = bufnr })):any(
              ---@param cli vim.lsp.Client
              function(cli)
                return vim.iter(peek_supported_capabilities):any(function(method)
                  return cli:supports_method(method, bufnr)
                end)
              end
            )
          end,
          execute = function(opts, done)
            local finished = false
            for _, method in ipairs(peek_supported_capabilities) do
              if
                vim.iter(vim.lsp.get_clients({ bufnr = opts.bufnr })):any(
                  ---@param cli vim.lsp.Client
                  function(cli)
                    return cli:supports_method(method, opts.bufnr)
                  end
                )
              then
                vim.lsp.buf_request(opts.bufnr, method, function(client, _bufnr)
                  return vim.lsp.util.make_position_params(0, client.offset_encoding)
                end, function(err, result, context, config)
                  if result == nil or vim.tbl_isempty(result) then
                    if not finished then
                      finished = true
                      return pcall(done, false)
                    else
                      return
                    end
                  end
                  local loc = result
                  if vim.islist(result) then
                    loc = result[1]
                  end
                  loc.uri = loc.uri or loc.targetUri
                  loc.range = loc.range or loc.targetRange
                  if loc.uri == nil or loc.range == nil then
                    if not finished then
                      finished = true
                      return pcall(done, false)
                    else
                      return
                    end
                  end
                  local _bufnr = vim.uri_to_bufnr(loc.uri)
                  vim.fn.bufload(_bufnr)
                  local range = loc.range
                  local ft = vim.bo[_bufnr].filetype
                  vim.treesitter.start(_bufnr, ft)

                  local md_lines = {
                    "```" .. ft,
                    string.format(vim.bo[_bufnr].commentstring, method),
                  }
                  vim.list_extend(
                    md_lines,
                    vim.api.nvim_buf_get_lines(
                      _bufnr,
                      range.start.line,
                      range.start.line + math.ceil(vim.api.nvim_win_get_height(0) * 0.2),
                      false
                    )
                  )
                  table.insert(md_lines, "```")
                  if not finished then
                    finished = true
                    return pcall(done, {
                      lines = md_lines,
                      filetype = "markdown",
                    })
                  else
                    return
                  end
                end)
                return
              end
            end
          end,
        })
      end,
      preview_opts = {
        -- border = "double",
      },
      preview_window = false,
      title = true,
      mouse_providers = {
        "LSP",
      },
      mouse_delay = 1000,
    },
    keys = {
      {
        "K",
        function()
          require("hover").hover()
        end,
        desc = "Trigger hover.",
        mode = "n",
        noremap = true,
      },
      {
        "[h",
        function()
          require("hover").hover_switch("previous")
        end,
        desc = "Previous hover provider.",
        mode = "n",
        noremap = true,
      },
      {
        "]h",
        function()
          require("hover").hover_switch("next")
        end,
        desc = "Next hover provider.",
        mode = "n",
        noremap = true,
      },
    },
  },
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
    "lewis6991/gitsigns.nvim",
    keys = {
      {
        "<Leader>gb",
        function()
          local gitsigns = require("gitsigns")
          gitsigns.toggle_current_line_blame()
          local msg = nil
          if require("gitsigns.config").config.current_line_blame then
            msg = "Enabled."
          else
            msg = "Disabled."
          end
          vim.notify(msg, "info", { title = "Git Blame" })
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
        "<Leader>gr",
        "<cmd>Gitsigns reset_hunk<cr>",
        noremap = true,
        desc = "Git [r]eset hunk.",
        mode = { "n", "x" },
      },
      {
        "<Leader>gp",
        "<cmd>Gitsigns preview_hunk<cr>",
        noremap = true,
        desc = "Git [p]review hunk.",
        mode = { "n", "x" },
      },
      {
        "]g",
        "<cmd>Gitsigns nav_hunk next<cr>",
        noremap = true,
        desc = "Next hunk.",
        mode = { "n" },
      },
      {
        "[g",
        "<cmd>Gitsigns nav_hunk prev<cr>",
        noremap = true,
        desc = "Next hunk.",
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
    },
    config = function(_, opts)
      require("gitsigns").setup(opts)
      vim.api.nvim_set_hl(0, "GitSignsCurrentLineBlame", { link = "Comment" })
    end,
    event = { "BufReadPost", "BufNewFile" },
    cmd = { "Gitsigns" },
  },
  { "nvim-lua/plenary.nvim" },
  {
    "smoka7/hop.nvim",
    opts = {},
    keys = {
      { "f", ":HopChar1<CR>", remap = false, mode = "n", desc = "Hop to character." },
      { "F", ":HopNodes<CR>", remap = false, mode = "n", desc = "Hop to node." },
    },
  },
  {
    "ibhagwan/fzf-lua",
    dependencies = { "echasnovski/mini.icons" },
    cmd = { "FzfLua" },
    opts = function(_, opts)
      return vim.tbl_deep_extend("force", opts or {}, {
        winopts = {
          border = "solid",
          width = 0.90,
          preview = {
            border = "solid",
            default = ((vim.fn.executable("bat") == 1) and "bat") or "cat",
            horizontal = "right:55%",
            vertical = "down:65%",
          },
        },
        files = { formatter = "path.dirname_first" },
        lsp = { code_actions = { previewer = "codeaction_native" } },
      })
    end,
    config = function(_, opts)
      require("fzf-lua").setup(opts)
      vim.api.nvim_set_hl(0, "FzfLuaBorder", { link = "FzfLuaNormal" })
      vim.api.nvim_set_hl(0, "FzfLuaTitle", { link = "FzfLuaBufName" })
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
    end,
    keys = {
      {
        "<Leader>a",
        "<cmd>FzfLua lsp_code_actions<cr>",
        remap = false,
        mode = { "n", "x" },
        desc = "Code actions",
      },
      {
        "<Leader>tf",
        "<cmd>FzfLua files<cr>",
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
        "<cmd>FzfLua grep<cr>",
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
  {
    "nvim-lualine/lualine.nvim",
    cond = utils.no_vscode,
    config = function()
      require("plugins._lualine")
    end,
    lazy = false,
    dependencies = { "echasnovski/mini.icons" },
  },
  {
    "shellRaining/hlchunk.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = function()
      local palette = require("catppuccin.palettes.mocha")
      local excluded_ft = {
        ["neo-tree"] = true,
        snacks_dashboard = true,
        fidget = true,
        help = true,
        snacks_picker_preview = true,
      }

      local indent_colors = {
        palette.surface0,
        palette.surface1,
        palette.surface2,
        palette.overlay0,
        palette.overlay1,
        palette.overlay2,
        palette.subtext0,
        palette.subtext1,
        palette.text,
      }
      return {
        chunk = {
          delay = 100,
          enable = true,
          exclude_filetypes = excluded_ft,
          style = palette.lavender,
        },
        indent = {
          enable = true,
          exclude_filetypes = excluded_ft,
          style = indent_colors,
        },
      }
    end,
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    cond = utils.no_vscode,
  },
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
    dependencies = { "echasnovski/mini.icons" },
    cmd = { "Oil" },
  },
  {
    "kylechui/nvim-surround",
    opts = {},
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      -- "nvim-treesitter/nvim-treesitter-textobjects",
    },
  },
  {
    "mtrajano/tssorter.nvim",
    version = "*",
    opts = {},
    keys = {
      {
        "<leader>s",
        function()
          require("tssorter").sort({})
        end,
        mode = { "n", "x" },
        desc = "sort selected treesitter nodes.",
      },
      {
        "<leader>s",
        function()
          require("tssorter").sort({ reverse = true })
        end,
        mode = { "n", "x" },
        desc = "sort selected treesitter nodes (reversed).",
      },
    },
  },
  -- {
  --   "nvim-treesitter/nvim-treesitter-textobjects",
  --   dependencies = {
  --     "nvim-treesitter/nvim-treesitter",
  --   },
  -- },
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
  { "backdround/tabscope.nvim", config = true },
  {
    "akinsho/toggleterm.nvim",
    keys = {
      {
        "<C-\\>",
        '<Esc><Cmd>execute v:count . "ToggleTerm"<CR>',
        mode = { "i", "n" },
        desc = "Toggle terminal.",
      },
    },
    config = true,
    opts = {
      open_mapping = "<C-\\>",
    },
  },
  {
    "jim-fx/sudoku.nvim",
    cmd = "Sudoku",

    opts = {
      mappings = {
        { key = "1", action = "insert=1" },
        { key = "2", action = "insert=2" },
        { key = "3", action = "insert=3" },
        { key = "4", action = "insert=4" },
        { key = "5", action = "insert=5" },
        { key = "6", action = "insert=6" },
        { key = "7", action = "insert=7" },
        { key = "8", action = "insert=8" },
        { key = "9", action = "insert=9" },
        { key = "0", action = "clear_cell" },
      },
    },
  },
  {
    "wintermute-cell/gitignore.nvim",
    cmd = "Gitignore",
    config = function()
      local gitignore = require("gitignore")
      local fzf = require("fzf-lua")

      gitignore.generate = function(opts)
        local picker_opts = {
          -- the content of opts.args may also be displayed here for example.
          prompt = "Select templates for gitignore file> ",
          winopts = {
            width = 0.4,
            height = 0.3,
          },
          actions = {
            default = function(selected, _)
              -- as stated in point (3) of the contract above, opts.args and
              -- a list of selected templateNames are passed.
              gitignore.createGitignoreBuffer(opts.args, selected)
            end,
          },
        }
        fzf.fzf_exec(function(fzf_cb)
          for _, prefix in ipairs(gitignore.templateNames) do
            fzf_cb(prefix)
          end
          fzf_cb()
        end, picker_opts)
      end
      vim.api.nvim_create_user_command(
        "Gitignore",
        gitignore.generate,
        { nargs = "?", complete = "file" }
      )
    end,
    dependencies = { "ibhagwan/fzf-lua" },
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
    "akinsho/git-conflict.nvim",
    config = true,
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
    "Davidyz/executable-checker.nvim",
    opts = {},
    event = "VeryLazy",
  },
  {
    "Sam-programs/cmdline-hl.nvim",
    event = { "CmdlineChanged", "CmdlineEnter" },
    opts = {
      inline_ghost_text = false,
      type_signs = { [":"] = { " ", "Title" }, ["/"] = { " ", "Title" } },
    },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
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
      return utils.any(
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
    "amitds1997/remote-nvim.nvim",
    cond = function()
      return utils.no_vscode() and utils.cpu_count() >= 2
    end,
    dependencies = {
      "nvim-lua/plenary.nvim", -- For standard functions
      "MunifTanjim/nui.nvim", -- To build the plugin UI
      "ibhagwan/fzf-lua",
    },
    opt = {},
    config = true,
    cmd = {
      "RemoteCleanup",
      "RemoteConfigDel",
      "RemoteInfo",
      "RemoteLog",
      "RemoteStart",
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
    "olimorris/codecompanion.nvim",
    -- dir = "~/git/codecompanion.nvim/",
    version = "*",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "Davidyz/VectorCode",
      "ibhagwan/fzf-lua",
      {
        "ravitemer/codecompanion-history.nvim",
        -- dir = "~/git/codecompanion-history.nvim/",
      },
      {
        "Davidyz/codecompanion-dap.nvim",
        -- dir = "~/git/codecompanion-dap.nvim/",
      },
    },
    cmd = {
      "CodeCompanion",
      "CodeCompanionCmd",
      "CodeCompanionChat",
      "CodeCompanionActions",
    },
    opts = function(_, opts)
      opts = opts or {}
      -- opts.opts = { log_level = "DEBUG" }
      opts.display = {
        action_palette = { provider = "fzf_lua" },
        chat = {
          show_header_separator = false,
          window = { sticky = true },
        },
      }
      opts.adapters = {
        ["Gemini"] = function()
          return require("codecompanion.adapters").extend("gemini", {
            name = "Gemini",
            schema = { model = { default = "gemini-2.5-flash" } },
          })
        end,
        ["LlamaCPP"] = function()
          return require("codecompanion.adapters").extend("openai_compatible", {
            env = {
              url = "http://127.0.0.1:8080",
              api_key = "TERM",
              chat_url = "/v1/chat/completions",
            },
          })
        end,
        ["Ollama"] = function()
          return require("codecompanion.adapters").extend("ollama", {
            env = {
              url = os.getenv("OLLAMA_HOST"),
              api_key = "TERM",
            },
            schema = {
              num_ctx = { default = 64000 },
              model = { default = "qwen3:8b-q4_K_M-dynamic-thinking" },
            },
          })
        end,
      }

      opts.extensions = {
        dap = {
          enabled = true,
          opts = { tool_opts = {}, interval_ms = 1 },
        },
        mcphub = { callback = "mcphub.extensions.codecompanion" },
        history = {
          enabled = true,
          opts = {
            keymap = "gh",
            save_chat_keymap = "sc",
            auto_save = true,
            expiration_days = 0,
            picker = "fzf-lua",
            auto_generate_title = true,
            continue_last_chat = false,
            delete_on_clearing_chat = false,
            title_generation_opts = {
              format_title = function(s)
                return vim.trim(string.gsub(s, "<think>.*</think>", ""))
              end,
            },
            summary = {
              create_summary_keymap = "gcs",
              browse_summaries_keymap = "gbs",
              preview_summary_keymap = "gps",

              generation_opts = {
                context_size = 90000,
                -- Include slash command content (default: true)
                include_references = true,
                -- Include tool outputs (default: true)
                include_tool_outputs = true,
                format_summary = function(s)
                  return vim.trim(string.gsub(s, "<think>.*</think>", ""))
                end,
              },
            },
            memory = { index_on_startup = true },
          },
        },
        vectorcode = {
          enabled = vim.fn.executable("vectorcode") == 1,
          ---@type VectorCode.CodeCompanion.ExtensionOpts
          opts = {
            tool_group = { extras = { "file_search" }, collapse = true },
            tool_opts = {
              ---@type VectorCode.CodeCompanion.ToolOpts
              ["*"] = { use_lsp = true },
              ls = {},
              vectorise = {},
              query = {
                default_num = { document = 15, chunks = 100 },
                chunk_mode = true,
                ---@type VectorCode.CodeCompanion.SummariseOpts
                summarise = {
                  enabled = true,
                  system_prompt = function(s)
                    return s
                  end,
                  adapter = function()
                    return require("codecompanion.adapters").extend("gemini", {
                      name = "Summariser",
                      schema = {
                        model = { default = "gemini-2.0-flash-lite" },
                      },
                      opts = { stream = false },
                    })
                  end,
                },
              },
            },
          },
        },
      }
      opts.strategies = {
        chat = {
          adapter = "Gemini",
          roles = {
            ---@type string|fun(adapter: CodeCompanion.Adapter): string
            llm = function(adapter)
              return string.format(
                "%s (%s)",
                adapter.formatted_name,
                adapter.model.name
              )
            end,
          },
          tools = {
            opts = { default_tools = { "vectorcode_toolbox", "read_file" } },
          },
          opts = {
            ---@param message string
            ---@param adapter CodeCompanion.Adapter
            ---@param context table
            ---@return string
            prompt_decorator = function(message, adapter, context)
              local root = vim.fs.root(0, { ".git", ".vectorcode" })
              if root == nil then
                return message
              else
                return string.format(
                  "%s\n\nI'm currently working on a project located at %s.",
                  message,
                  root
                )
              end
            end,
          },
        },
        inline = {
          adapter = "Gemini",
        },
      }

      -- opts.display = { chat = { show_references = false } }

      if os.getenv("OPENROUTER_API_KEY") then
        opts.adapters["OpenRouter"] = function()
          return require("codecompanion.adapters").extend("openai_compatible", {
            env = {
              url = "https://openrouter.ai/api",
              api_key = "OPENROUTER_API_KEY",
              chat_url = "/v1/chat/completions",
            },
            schema = {
              model = {
                default = "deepseek/deepseek-chat-v3-0324:free",
              },
            },
          })
        end
        opts.strategies.chat.adapter = "OpenRouter"
        opts.strategies.inline.adapter = "OpenRouter"
      end
      if os.getenv("SILICONFLOW_API_KEY") then
        opts.adapters["SiliconFlow"] = function()
          return require("codecompanion.adapters").extend("openai_compatible", {
            env = {
              url = "https://api.siliconflow.cn/",
              api_key = "SILICONFLOW_API_KEY",
              chat_url = "/v1/chat/completions",
            },
            schema = {
              model = {
                default = "Qwen/Qwen2.5-72B-Instruct-128K",
              },
            },
          })
        end
        opts.strategies.chat.adapter = "SiliconFlow"
        opts.strategies.inline.adapter = "SiliconFlow"
      end
      if os.getenv("QWEN_API_KEY") then
        opts.adapters["Qwen"] = function()
          return require("codecompanion.adapters").extend("openai_compatible", {
            env = {
              url = "https://dashscope.aliyuncs.com/compatible-mode",
              api_key = "QWEN_API_KEY",
              chat_url = "/v1/chat/completions",
            },
            schema = {
              model = {
                default = "qwen-turbo-2025-04-28",
              },
              temperature = { default = 0.6 },
            },
          })
        end
        opts.strategies.chat.adapter = "Qwen"
        opts.strategies.inline.adapter = "Qwen"
      end
      return opts
    end,
    cond = function()
      return utils.no_vscode()
    end,
    keys = {
      {
        "<leader>ca",
        "<cmd>CodeCompanionActions<cr>",
        mode = "n",
        noremap = true,
        desc = "[C]odeCompanion [a]ctions.",
      },
      {
        "<leader>cc",
        "<cmd>CodeCompanionChat<cr>",
        mode = "n",
        noremap = true,
        desc = "[C]odeCompanion [c]hat.",
      },
      {
        "<leader>ct",
        "<cmd>CodeCompanionChat Toggle<cr>",
        mode = "n",
        noremap = true,
        desc = "[C]odeCompanion chat [t]oggle.",
      },
    },
  },
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    dependencies = {
      "github/copilot.vim", -- or zbirenbaum/copilot.lua
      "nvim-lua/plenary.nvim", -- for curl, log and async functions
    },
    build = "make tiktoken", -- Only on MacOS or Linux
    cmd = { "CopilotChat" },
    opts = function(_, opts)
      opts = vim.tbl_deep_extend("force", opts or {}, {
        contexts = {
          vectorcode = require("vectorcode.integrations.copilotchat").make_context({
            prompt_header = "Here are relevant files from the repository:",
            prompt_footer = "\nConsider this context when answering:",
            skip_empty = true,
          }),
        },
        prompts = {
          Explain = {
            prompt = "Explain the following code in detail:\n$input",
            -- context = { "selection", "vectorcode" }, -- Add vectorcode to the context
          },
        },
      })
      return opts
    end,
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
        { "<leader>t", group = "Fzf-lua" },
        { "<leader>r", group = "Refactoring" },
        { "<leader>e", group = "Extract" },
        { "<leader>g", group = "Git integrations" },
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
    cond = utils.no_vscode(),
  },
  {
    "3rd/image.nvim",
    filetypes = { "markdown" },
    dependencies = { "leafo/magick" },
    cond = function()
      return vim.fn.executable("magick") == 1
        and utils.no_vscode()
        and utils.no_neovide()
        and vim.fn.executable("lua5.1") == 1
    end,
    opts = function()
      return {
        backend = "kitty",
        max_width_window_percentage = 200 / 3,
        integrations = {
          markdown = {
            clear_in_insert_mode = true,
            only_render_image_at_cursor = true,
          },
        },
        window_overlap_clear_enabled = true,
        editor_only_render_when_focused = true,
      }
    end,
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
      return utils.no_vscode()
    end,
  },
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
    "andythigpen/nvim-coverage",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      commands = true,
      auto_reload = true,
      signs = { covered = { hl = "LineNr" }, uncovered = { hl = "Exception" } },
    },
    config = function(_, opts)
      local cov = require("coverage")
      cov.setup(opts)
      cov.load(true)
    end,
    keys = {
      {
        "]C",
        function()
          require("coverage").jump_next("uncovered")
        end,
        desc = "Next uncovered snippet.",
        noremap = true,
      },
      {
        "[C",
        function()
          require("coverage").jump_prev("uncovered")
        end,
        desc = "Previous uncovered snippet.",
        noremap = true,
      },
    },
    cmd = { "Coverage" },
  },
  {
    "nvim-neotest/neotest",
    config = function()
      local default_python = require("venv-selector").python()
        or vim.fs.joinpath(
          vim.fs.root(0, { ".venv", "pyproject.toml", ".git" }) or ".",
          ".venv/bin/python"
        )
      local stat = vim.uv.fs_stat(default_python)
      if not stat or stat.type ~= "file" then
        default_python = "python"
      end
      require("neotest").setup({
        adapters = {
          require("neotest-python")({
            dap = { justMyCode = true },
            args = { "--log-level", "DEBUG" },
            runner = "pytest",
            python = default_python,
          }),
        },
      })

      vim.api.nvim_create_autocmd("FileType", {
        pattern = "neotest-*",
        callback = function()
          for _, lhs in pairs({ "q", "<esc>" }) do
            vim.keymap.set("n", lhs, function()
              vim.cmd("quit")
            end, { buffer = 0 })
          end
        end,
      })
    end,
    version = "*",
    keys = {
      {
        "<Space>tf",
        function()
          require("neotest").run.run()
        end,
        desc = "[T]est nearest [f]unction",
      },
      {
        "<Space>tF",
        function()
          require("neotest").run.run({ strategy = "dap" })
        end,
        desc = "[T]est nearest [f]unction (dap)",
      },
      {
        "<Space>to",
        function()
          require("neotest").output.open({ short = true, enter = true })
        end,
        desc = "[T]est [o]utput",
      },
      {
        "<Space>ts",
        function()
          require("neotest").run.stop()
        end,
        desc = "[S]top",
      },
      {
        "<Space>at",
        function()
          require("neotest").run.attach()
        end,
        desc = "[A]ttach to [t]est",
      },
      {
        "<Space>ta",
        function()
          local buf_name = vim.api.nvim_buf_get_name(0)
          local stat = vim.uv.fs_stat(buf_name)
          if stat ~= nil and stat.type == "file" then
            require("neotest").run.run(buf_name)
            require("neotest").summary.open()
          end
        end,
        desc = "[T]est [a]ll cases in current file",
      },
      {
        "<Space>tA",
        function()
          local root_dir = vim.fs.root(0, { "tests", "test" })
          if root_dir == nil then
            return
          end
          local stat
          for _, dir in pairs({ "tests", "test" }) do
            local test_dir = vim.fs.joinpath(root_dir, dir)
            stat = vim.uv.fs_stat(test_dir)
            if stat and stat.type == "directory" then
              require("neotest").run.run(test_dir)
              require("neotest").summary.open()
              return
            end
          end
        end,
        desc = "Run all tests.",
      },
    },
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
  },
  { "nvim-neotest/neotest-python", ft = { "python" } },
  { "nvim-telescope/telescope.nvim", enabled = false },
}

for _, spec in pairs(M.plugins) do
  if spec.dir ~= nil then
    spec.dir = vim.fn.expand(spec.dir)
    if vim.fn.isdirectory(spec.dir) == 0 then
      -- remove this attribute if no local dir.
      spec.dir = nil
    end
  end
end

M.config = {
  defaults = { lazy = true },
  dev = { fallback = true },
  install = { colorscheme = { "catppuccin-mocha" } },
  profiling = { loader = true, require = true },
  ui = {
    border = "solid",
    backdrop = 100,
  },
}

return M
