M = {}
local utils = require("_utils")

local icon_provider = "echasnovski/mini.icons"
M.plugins = {
  -- NOTE: icons
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
    cond = function()
      return icon_provider == "echasnovski/mini.icons"
    end,
  },
  {
    "nvim-tree/nvim-web-devicons",
    cond = function()
      return icon_provider == "nvim-tree/nvim-web-devicons"
    end,
    dependencies = {},
  },

  -- NOTE: filetypes
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
            TelescopeNormal = {
              bg = colors.mantle,
              fg = colors.text,
            },
            TelescopeBorder = {
              bg = colors.mantle,
              fg = colors.mantle,
            },
            TelescopePromptNormal = {
              bg = colors.crust,
              fg = colors.lavender,
            },
            TelescopePromptBorder = {
              bg = colors.crust,
              fg = colors.crust,
            },
            TelescopePromptTitle = {
              bg = colors.crust,
              fg = colors.crust,
            },
            TelescopePreviewTitle = {
              bg = colors.mantle,
              fg = colors.mantle,
            },
            TelescopeResultsTitle = {
              bg = colors.mantle,
              fg = colors.mantle,
            },
            FloatBorder = { fg = colors.mantle, bg = colors.mantle },
            FloatTitle = { fg = colors.lavender, bg = colors.mantle },
            LspInfoBorder = { fg = colors.mantle, bg = colors.mantle },
            WinSeparator = { bg = colors.base, fg = colors.lavender },
          }
        end,
        dim_inactive = { enabled = false },
        default_integrations = {
          diffview = true,
          fidget = true,
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
          snacks = true,
          which_key = true,
        },
      }
    end,
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    opts = function()
      vim.treesitter.language.register("markdown", "vimwiki")
      return { file_types = { "markdown", "vimwiki" } }
    end,
    ft = { "markdown", "vimwiki" },
    dependencies = { "nvim-treesitter/nvim-treesitter", icon_provider },
  },

  -- NOTE: tree sitter
  {
    "nvim-treesitter/nvim-treesitter",
    config = function()
      require("plugins.tree_sitter")
    end,
    build = ":TSUpdate",
    cond = utils.no_vscode,
    dependencies = { "williamboman/mason.nvim" },
  },
  {
    "hiphish/rainbow-delimiters.nvim",
    event = { "BufReadPost", "BufNewFile" },
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
    event = "LspAttach",
  },
  {
    "andymass/vim-matchup",
    event = { "BufReadPost", "BufNewFile" },
    init = function()
      vim.g.matchup_matchparen_offscreen =
        { method = "popup", fullwidth = 1, highlight = "Comment" }
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
      "neovim/nvim-lspconfig",
    },
    cond = utils.no_vscode,
    init = function()
      vim.o.foldenable = true
      vim.o.foldlevel = 99
      vim.o.foldlevelstart = 99
      vim.o.foldcolumn = "0"
    end,
    config = function(_, opts)
      require("ufo").setup(opts)
      vim.api.nvim_set_hl(0, "UfoCursorFoldedLine", { link = "CursorLine" })
      vim.api.nvim_set_hl(0, "UfoPreviewBg", { link = "TelescopePreviewBorder" })
      vim.api.nvim_set_hl(0, "UfoPreviewWinBar", { link = "TelescopePreviewBorder" })
      vim.api.nvim_set_hl(0, "UfoFoldedBg", { link = "CursorLine" })
      vim.keymap.set("n", "<C-p>", function()
        require("ufo.preview"):peekFoldedLinesUnderCursor()
      end, { noremap = true, desc = "Peek inside fold." })
      vim.keymap.set("n", "<BS>", "za", { noremap = true, desc = "Toggle fold." })
    end,
    opts = {
      preview = {
        win_config = { winhighlight = "Normal:TelescopePreviewBorder", winblend = 0 },
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
        table.insert(result, { "  ", "NonText" })
        table.insert(result, { suffix, "TSPunctBracket" })
        return result
      end,
      provider_selector = function(bufnum, _, _)
        if vim.bo.bt == "nofile" then
          return ""
        end
        local servers = vim.lsp.get_clients({ bufnr = bufnum })
        if
          #servers > 0
          and utils.any(servers, function(server)
            return server.server_capabilities.foldingRangeProvider == true
          end)
        then
          return { "lsp", "treesitter" }
        end
        return { "treesitter", "indent" }
      end,
    },
    event = { "LspAttach" },
  },
  {
    "rachartier/tiny-inline-diagnostic.nvim",
    event = { "LspAttach" },
    dependencies = { "neovim/nvim-lspconfig", "nvimtools/none-ls.nvim" },
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
      ui = { height = 0.8 },
      max_concurrent_jobs = math.min(4, utils.cpu_count()),
      PATH = "append",
    },
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    event = { "BufReadPost", "BufNewFile" },
    cmd = { "MasonToolsInstall", "MasonToolsUpdate", "MasonToolsClean" },
    config = function()
      require("plugins.mason_tools")
    end,
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      {
        "jay-babu/mason-null-ls.nvim",
        dependencies = {
          "williamboman/mason.nvim",
          "nvimtools/none-ls.nvim",
        },
        opts = {
          ensure_installed = nil,
          automatic_installation = true,
        },
        config = true,
      },
    },
  },
  {
    "nvimtools/none-ls.nvim",
    event = { "BufReadPost", "BufNewFile" },
    config = require("plugins.null_ls"),
    dependencies = { "williamboman/mason.nvim" },
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
    event = { "BufReadPost", "BufNewFile", "CmdlineEnter" },
    cond = utils.no_vscode,
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
  },
  {
    "williamboman/mason-lspconfig.nvim",
    cond = utils.no_vscode,
  },
  {
    "saghen/blink.cmp",
    dependencies = {
      "rafamadriz/friendly-snippets",
      "milanglacier/minuet-ai.nvim",
      "folke/lazydev.nvim",
      "moyiz/blink-emoji.nvim",
      {
        "Kaiser-Yang/blink-cmp-dictionary",
        dependencies = { "nvim-lua/plenary.nvim" },
      },
    },
    event = { "BufReadPost", "CmdlineEnter" },
    version = "*",
    opts = require("plugins.blink"),
    opts_extend = { "sources.default" },
    cond = utils.no_vscode,
  },
  {
    "xzbdmw/colorful-menu.nvim",
    opts = { max_width = 0.3 },
  },
  {
    "Davidyz/VectorCode",
    version = "*",
    config = function(_, opts)
      require("vectorcode").setup(opts)
      local cacher = require("vectorcode.cacher")
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function()
          local bufnr = vim.api.nvim_get_current_buf()
          cacher.async_check("config", function()
            cacher.register_buffer(
              bufnr,
              { notify = false, n_query = 10 },
              require("vectorcode.utils").lsp_document_symbol_cb(),
              { "BufWritePost" },
              15
            )
          end, nil)
        end,
        desc = "Register buffer for VectorCode",
      })
    end,
    opts = { notify = false, n_query = 10 },
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
  },
  {
    "milanglacier/minuet-ai.nvim",
    config = function(_, opts)
      local vectorcode_cacher = require("vectorcode.cacher")
      local num_docs = 10
      opts = {
        add_single_line_entry = true,
        n_completions = 1,
        after_cursor_filter_length = 0,
        provider_options = {},
      }

      local ollama_host = os.getenv("OLLAMA_HOST")
      if not utils.no_vscode() or ollama_host == nil or ollama_host == "" then
        return false
      end
      local ok, _ = pcall(require("plenary.curl").get, ollama_host, { timeout = 1000 })
      if ok then
        opts.provider = "openai_fim_compatible"
        opts.provider_options.openai_fim_compatible = {
          api_key = "TERM",
          name = "Ollama",
          stream = false,
          end_point = os.getenv("OLLAMA_HOST") .. "/v1/completions",
          model = os.getenv("OLLAMA_CODE_MODEL"),
          optional = {
            max_tokens = 256,
            top_p = 0.9,
            num_ctx = 16384,
          },
          request_timeout = 10,
          n_completions = 5,
          template = {
            prompt = function(pref, suff)
              local prompt_message = ""
              local cache_result = vectorcode_cacher.query_from_cache(0)
              num_docs = #cache_result
              for _, file in ipairs(cache_result) do
                prompt_message = "<|file_sep|>" .. file.path .. "\n" .. file.document
              end
              return prompt_message
                .. "<|fim_prefix|>"
                .. pref
                .. "<|fim_suffix|>"
                .. suff
                .. "<|fim_middle|>"
            end,
            suffix = nil,
          },
        }
      end
      require("minuet").setup(opts)
      if ok then
        local openai_fim_compatible = require("minuet.backends.openai_fim_compatible")
        local orig_get_text_fn = openai_fim_compatible.get_text_fn
        openai_fim_compatible.get_text_fn = function(json)
          vim.g.ai_raw_response = json
          if vectorcode_cacher.buf_is_registered() then
            local new_num_query = num_docs
            if vim.g.ai_raw_response.usage.total_tokens > 16384 then
              new_num_query = math.max(num_docs - 1, 1)
            elseif vim.g.ai_raw_response.usage.total_tokens < 16000 then
              new_num_query = num_docs + 1
            end
            vectorcode_cacher.register_buffer(
              0,
              { n_query = new_num_query },
              nil,
              { "BufWritePost" },
              10
            )
          end
          return orig_get_text_fn(json)
        end
      end
    end,
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
    dependencies = { "neovim/nvim-lspconfig" },
  },
  -- {
  --   "tamago324/cmp-zsh",
  --   build = function()
  --     if vim.fn.executable("zsh") then
  --       io.popen('zsh -c "zmodload zsh/zpty"')
  --     end
  --   end,
  --   main = "cmp_zsh",
  --   opts = { zshrc = true, filetypes = { "zsh" } },
  --   cond = function()
  --     return utils.no_vscode() and vim.fn.executable("zsh") ~= 0
  --   end,
  --   ft = { "zsh" },
  -- },
  -- { "kdheepak/cmp-latex-symbols", event = { "InsertEnter" } },
  {
    "j-hui/fidget.nvim",
    event = "LspAttach",
    version = "*",
    opts = {
      notification = {
        window = {
          winblend = 0,
          align = "bottom",
          x_padding = 0,
          border = { "" },
        },
        view = { stack_upwards = false },
      },
    },
    cond = utils.no_vscode,
  },
  {
    "aznhe21/actions-preview.nvim",
    keys = {
      {
        "<Leader>a",
        [[<cmd>lua require("actions-preview").code_actions()<cr>]],
        mode = { "v", "n" },
        desc = "Code Actions",
      },
    },
    dependencies = { "nvim-telescope/telescope.nvim" },
    opts = function()
      return {
        telescope = {
          sorting_strategy = "ascending",
          layout_strategy = "vertical",
          layout_config = {
            width = 0.8,
            height = 0.9,
            prompt_position = "top",
            preview_cutoff = 20,
            preview_height = function(_, _, max_lines)
              return max_lines - 15
            end,
          },
        },
      }
    end,
    cond = utils.no_vscode,
  },
  {
    "smjonas/inc-rename.nvim",
    opts = {
      input_buffer_type = "dressing",
    },
    dependencies = { "stevearc/dressing.nvim" },
    cmd = { "IncRename" },
    keys = {
      {
        "<Leader>rv",
        function()
          return ":IncRename " .. vim.fn.expand("<cword>")
        end,
        mode = "n",
        expr = true,
        desc = "LSP rename.",
      },
    },
  },
  {
    "ThePrimeagen/refactoring.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "nvim-telescope/telescope.nvim",
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
      require("telescope").load_extension("refactoring")
    end,
    keys = {
      {
        "<leader>ef",
        function()
          require("refactoring").refactor("Extract Function")
        end,
        desc = "Extract Function",
        noremap = true,
        mode = { "x" },
      },
      {
        "<leader>ev",
        function()
          require("refactoring").refactor("Extract Variable")
        end,
        desc = "Extract Variable",
        noremap = true,
        mode = { "x" },
      },
      {
        "<leader>if",
        function()
          require("refactoring").refactor("Inline Function")
        end,
        desc = "Inline Function",
        noremap = true,
        mode = { "x" },
      },
      {
        "<leader>iv",
        function()
          require("refactoring").refactor("Inline Variable")
        end,
        desc = "Inline Variable",
        noremap = true,
        mode = { "x" },
      },
      {
        "<leader>eb",
        function()
          require("refactoring").refactor("Extract Block")
        end,
        desc = "Extract block",
        noremap = true,
        mode = { "n" },
      },
      {
        "<leader>ebf",
        function()
          require("refactoring").refactor("Extract Block To File")
        end,
        desc = "Extract block to file",
        noremap = true,
        mode = { "n" },
      },
      {
        "<leader>rp",
        function()
          require("refactoring").debug.print_var({})
        end,
        mode = { "n" },
        desc = "Add debug print statement.",
      },
      {
        "<leader>rc",
        function()
          require("refactoring").debug.cleanup({})
        end,
        mode = { "n" },
        desc = "Clear debug print statement.",
      },
      {
        "<leader>rr",
        function()
          require("telescope").extensions.refactoring.refactors({
            theme = "cursor",
            layout_config = { width = 0.4, height = 0.4 },
            layout_strategy = "cursor",
          })
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
      },
    },
    dependencies = {
      { "Bilal2453/luvit-meta" },
      { "justinsgithub/wezterm-types" },
      { "folke/snacks.nvim" },
    },
  },
  {
    "barreiroleo/ltex_extra.nvim",
    ft = { "markdown", "tex" },
    dependencies = { "neovim/nvim-lspconfig" },
    config = false,
    cond = function()
      if vim.fn.executable("java") then
        local output = vim.fn.execute("!java -version") or ""
        local java_ver_num = string.match(output, "build (%d+)") or 0
        return tonumber(java_ver_num) > 11
      end
      return false
    end,
  },
  {
    "linux-cultist/venv-selector.nvim",
    branch = "regexp",
    dependencies = { "neovim/nvim-lspconfig" },
    ft = { "python" },
    cmd = { "VenvSelect", "VenvSelectCurrent" },
    opts = function()
      return {
        settings = {
          options = {
            activate_venv_in_terminal = true,
            cached_venv_automatic_activation = true,
            notify_user_on_venv_activation = true,
            telescope_active_venv_color = require("catppuccin.palettes.mocha").lavender,
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
        "<Leader>i",
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
      -- require("keymaps.dap")
    end,
    keys = {
      {
        "<leader>d",
        function()
          require("dapui").toggle()
        end,
        desc = "Toggle DAP UI.",
      },
      { "<F5>", "<cmd>DapContinue<CR>", desc = "DAP Continue." },
      { "<Space>o", "<cmd>DapStepOver<CR>", desc = "DAP Step [O]ver.", noremap = true },
      { "<Space>i", "<cmd>DapStepOver<CR>", desc = "DAP Step [I]nto.", noremap = true },
      { "<Space>q", "<cmd>DapStepOut<CR>", desc = "DAP Step Out.", noremap = true },
      {
        "<Space>b",
        "<cmd>DapToggleBreakpoint<CR>",
        desc = "DAP Toggle [B]reakpoint.",
        noremap = true,
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
        cond = utils.no_vscode,
      },
      {
        "rcarriga/nvim-dap-ui",
        cond = utils.no_vscode,
        dependencies = { "nvim-neotest/nvim-nio" },
      },
      {
        "jbyuki/one-small-step-for-vimkind",
        cond = utils.no_vscode,
      },
      {
        "jay-babu/mason-nvim-dap.nvim",
        cond = utils.no_vscode,
      },
    },
  },

  -- NOTE: misc
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    version = "*",
    opts = function()
      return {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
        -- input = { enabled = true, relative = "cursor", row = -3, col = 0 },
        bigfile = { enabled = true },
        dashboard = {
          enabled = true,
          wo = { statusline = nil },
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
        notifier = { enabled = true },
        profiler = { enabled = true },
        quickfile = { enabled = true },
        rename = { enabled = true },
        statuscolumn = {
          enabled = true,
          left = { "mark", "sign", "git" },
          right = { "fold" },
        },
        words = { enabled = true },
        scroll = { animate = { easing = "inOutCirc" } },
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
        "<cmd>TodoTelescope<CR>",
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
      "nvim-telescope/telescope.nvim",
      "nvim-lua/plenary.nvim", -- required by telescope
      "MunifTanjim/nui.nvim",

      -- optional
      "nvim-treesitter/nvim-treesitter",

      icon_provider,
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
    "stevearc/dressing.nvim",
    opts = { input = { title_pos = "center", border = "rounded" } },
  },
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
        require("hover.providers.diagnostic")
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
    "nvim-telescope/telescope.nvim",
    version = "*",
    keys = {
      {
        "<Leader>tf",
        function()
          require("telescope.builtin").find_files({})
        end,
        remap = false,
        mode = "n",
        desc = "Fuzzy find files.",
      },
      {
        "<Leader>tb",
        function()
          require("telescope.builtin").buffers({})
        end,
        remap = false,
        mode = "n",
        desc = "Show buffers.",
      },
      {
        "<Leader>tq",
        function()
          require("telescope.builtin").quickfix({})
        end,
        remap = false,
        mode = "n",
        desc = "Show quickfix.",
      },
      {
        "<Leader>tD",
        function()
          require("telescope.builtin").diagnostics({})
        end,
        remap = false,
        mode = "n",
        desc = "Project-wise diagnostics.",
      },
      {
        "<Leader>td",
        function()
          require("telescope.builtin").diagnostics({
            bufnr = 0,
          })
        end,
        remap = false,
        mode = "n",
        desc = "Buffer diagnostics.",
      },
      {
        "<Leader>th",
        function()
          require("telescope.builtin").help_tags({})
        end,
        remap = false,
        mode = "n",
        desc = "Find help tags.",
      },
      {
        "R",
        function()
          require("telescope.builtin").live_grep({})
        end,
        remap = false,
        mode = "n",
        desc = "Live grep.",
      },
      {
        "<Leader>f",
        function()
          require("telescope.builtin").current_buffer_fuzzy_find({})
        end,
        remap = false,
        mode = "n",
        desc = "Fuzzy find current buffer.",
      },
      {
        "<Leader>tr",
        function()
          require("telescope.builtin").resume()
        end,
        remap = false,
        mode = "n",
        desc = "Resume last telescope session",
      },
    },
    config = function(_, opts)
      require("telescope").setup(opts)
      require("telescope").load_extension("ui-select")
    end,
    cmd = "Telescope",
    opts = function()
      return {
        defaults = {
          layout_strategy = "flex",
          layout_config = {
            prompt_position = "top",
            horizontal = { preview_width = 0.6 },
            vertical = { preview_height = 0.6 },
          },
          sorting_strategy = "ascending",
          mappings = {
            n = {
              ["<esc>"] = require("telescope.actions").close,
            },
          },
        },
        extensions = {
          ["ui-select"] = { require("telescope.themes").get_dropdown() },
          fzf = {},
        },
      }
    end,
    dependencies = {
      "nvim-telescope/telescope-fzf-native.nvim",
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-ui-select.nvim",
    },
  },
  {
    "jmacadie/telescope-hierarchy.nvim",
    dependencies = {
      {
        "nvim-telescope/telescope.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
      },
    },
    keys = {
      {
        "<leader>ti",
        "<cmd>Telescope hierarchy incoming_calls<cr>",
        desc = "Incoming Function call.",
      },
      {
        "<leader>to",
        "<cmd>Telescope hierarchy outgoing_calls<cr>",
        desc = "Outgoing Function call.",
      },
    },
    opts = function()
      return {
        extensions = {
          hierarchy = { layout_strategy = "flex" },
        },
      }
    end,
    config = function(_, opts)
      require("telescope").setup(opts)
      require("telescope").load_extension("hierarchy")
    end,
    cond = function()
      return utils.no_vscode() and vim.fn.has("nightly") == 0
    end,
  },
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = "make",
    cond = function()
      return utils.no_vscode() and vim.fn.executable("make") == 1
    end,
    config = function(_, opts)
      require("telescope").setup(opts)
      require("telescope").load_extension("fzf")
    end,
    opts = { extensions = { fzf = {} } },
  },
  {
    "debugloop/telescope-undo.nvim",
    dependencies = {
      {
        "nvim-telescope/telescope.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
      },
    },
    keys = {
      {
        "<leader>tu",
        "<cmd>Telescope undo<cr>",
        desc = "undo history",
      },
    },
    opts = {
      extensions = {
        undo = {
          use_delta = vim.fn.executable("delta") == 1,
          layout_strategy = "vertical",
          layout_config = {
            width = 0.8,
            height = 0.9,
            prompt_position = "top",
            preview_cutoff = 20,
            preview_height = function(_, _, max_lines)
              return max_lines - 15
            end,
          },
        },
      },
    },
    config = function(_, opts)
      require("telescope").setup(opts)
      require("telescope").load_extension("undo")
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    cond = utils.no_vscode,
    config = function()
      require("plugins._lualine")
    end,
    lazy = false,
    dependencies = { icon_provider },
  },
  {
    "shellRaining/hlchunk.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = function()
      local palette = require("catppuccin.palettes.mocha")
      local excluded_ft =
        { ["neo-tree"] = true, snacks_dashboard = true, fidget = true, help = true }

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
        Snacks.rename.on_rename_file(data.source, data.destination)
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
      },
    },
    ft = { "netrw" },
    cmd = { "Neotree" },
  },
  {
    "stevearc/oil.nvim",
    version = "*",
    opts = { lsp_file_methods = { autosave_changes = true } },
    dependencies = { icon_provider },
    cmd = { "Oil" },
  },
  {
    "kylechui/nvim-surround",
    opts = {},
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
  },
  {
    "mtrajano/tssorter.nvim",
    version = "*",
    opts = {},
    keys = {
      {
        "<Leader>s",
        function()
          require("tssorter").sort({})
        end,
        mode = { "n", "x" },
        desc = "Sort selected treesitter nodes.",
      },
      {
        "<Leader>S",
        function()
          require("tssorter").sort({ reverse = true })
        end,
        mode = { "n", "x" },
        desc = "Sort selected treesitter nodes (reversed).",
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
  },
  {
    "nvim-focus/focus.nvim",
    opts = {},
    config = true,
    event = "WinNew",
    init = function()
      local ignore_filetypes = { "neo-tree", "Outline" }
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
    "pappasam/nvim-repl",
    init = function()
      vim.g.repl_filetype_commands = { python = "ipython" }
      if vim.fn.executable("ipython") == 0 then
        vim.g.repl_filetype_commands.python = "python"
      end
      vim.g.repl_split = "bottom"
    end,
    keys = { { "<C-|>", "<cmd>ReplToggle<cr>", desc = "Toggle repl" } },
    cmd = { "Repl", "ReplOpen", "ReplRunCell" },
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
    dependencies = { "nvim-telescope/telescope.nvim" },
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
    config = true,
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
      "nvim-telescope/telescope.nvim", -- For picking b/w different remote methods
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
  },
  {
    "olimorris/codecompanion.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    config = true,
    cmd = {
      "CodeCompanion",
      "CodeCompanionCmd",
      "CodeCompanionChat",
      "CodeCompanionActions",
    },
    opts = function(_, opts)
      opts = opts or {}
      opts.adapters = {
        ["Qwen2.5-Coder"] = function()
          return require("codecompanion.adapters").extend("ollama", {
            name = "Qwen2.5-Coder",
            env = {
              url = os.getenv("OLLAMA_HOST"),
            },
            schema = {
              model = {
                default = os.getenv("OLLAMA_CODE_CHAT_MODEL"),
              },
              num_ctx = { default = 16 * 1024 },
            },
          })
        end,
      }

      opts.strategies = {
        chat = {
          adapter = "Qwen2.5-Coder",
        },
        inline = {
          adapter = "Qwen2.5-Coder",
        },
      }
      return opts
    end,
    cond = function()
      local ollama_host = os.getenv("OLLAMA_HOST")
      if
        not utils.no_vscode()
        or ollama_host == nil
        or ollama_host == ""
        or os.getenv("OLLAMA_CODE_CHAT_MODEL") == nil
      then
        return false
      end
      local ok, result =
        pcall(require("plenary.curl").get, ollama_host, { timeout = 1000 })
      return ok
    end,
  },
  {
    "folke/which-key.nvim",
    event = "BufEnter",
    opts = {
      preset = "modern",
    },
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
      unstar_on_uninstall = true,
      ask_before_unstarring = true,
      ignore_unauthenticated = true,
    },
    event = { "VeryLazy" },
    cond = function()
      return utils.no_vscode()
    end,
  },
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
    border = "none",
    backdrop = 100,
  },
}

return M
