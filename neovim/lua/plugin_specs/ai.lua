---@module "lazy"

---@module "vectorcode"
---@module "codecompanion"

---@type LazySpec[]
return {
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
          },
        },
      })
      return opts
    end,
  },

  {
    "olimorris/codecompanion.nvim",
    -- dir = "~/git/codecompanion.nvim/",
    -- version = "*",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "Davidyz/VectorCode",
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
    opts = function(plugin, opts)
      ---@module "codecompanion.config"
      opts = opts or {}
      opts.opts = opts.opts or {}

      -- opts.opts = { log_level = "DEBUG" }
      opts.display = {
        action_palette = { provider = "snacks" },
        chat = {
          show_header_separator = false,
          window = { sticky = true },
        },
      }
      opts.adapters = {
        acp = {
          gemini_cli = function()
            return require("codecompanion.adapters").extend("gemini_cli", {
              commands = {
                ["Gemini 2.5 Pro"] = {
                  "gemini",
                  "--experimental-acp",
                  "-m",
                  "gemini-2.5-pro",
                },
                ["Gemini 2.5 Flash"] = {
                  "gemini",
                  "--experimental-acp",
                  "-m",
                  "gemini-2.5-flash",
                },
              },
              defaults = {
                auth_method = "oauth-personal",
                -- mcpServers = require("mcphub").get_hub_instance():get_servers(),
                timeout = 20000, -- 20 seconds
              },
              env = {
                HTTP_PROXY = vim.env.HTTP_PROXY,
                HTTPS_PROXY = vim.env.HTTPS_PROXY,
              },
            })
          end,
        },
        http = {
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
                api_key = "LLAMACPP_API_KEY",
                chat_url = "/v1/chat/completions",
              },
              schema = {
                cache_prompt = { default = true, mapping = "parameters" },
                model = { default = "qwen3-coder-30b-a3b" },
              },
              handlers = {
                parse_message_meta = function(self, data)
                  local extra = data.extra
                  if extra and extra.reasoning_content then
                    data.output.reasoning = { content = extra.reasoning_content }
                  end
                  if data.output.content == "" then
                    data.output.content = nil
                  end
                  return data
                end,
              },
            })
          end,

          ["OpenRouter"] = function()
            return require("codecompanion.adapters").extend("openai_compatible", {
              env = {
                url = "https://openrouter.ai/api",
                api_key = "OPENROUTER_API_KEY",
                chat_url = "/v1/chat/completions",
              },
              handlers = {
                parse_extra = function(self, data)
                  local extra = data.extra
                  if extra and extra.reasoning then
                    data.output.reasoning = { content = extra.reasoning }
                    if data.output.content == "" then
                      data.output.content = nil
                    end
                  end
                  return data
                end,
              },
            })
          end,
          ["Ollama"] = function()
            return require("codecompanion.adapters").extend("ollama", {
              env = {
                url = os.getenv("OLLAMA_HOST"),
                api_key = "TERM",
              },
              name = "Ollama",
              schema = {
                num_ctx = { default = 64000 },
                -- model = { default = { "qwen3:8b-q4_K_M-dynamic-thinking" } },
                -- think = { default = true },
              },
            })
          end,
        },
      }

      opts.extensions = {
        dap = {
          enabled = true,
          opts = { tool_opts = {}, interval_ms = 1 },
        },
        mcphub = { callback = "mcphub.extensions.codecompanion" },
        history = {
          enabled = false,
          opts = {
            keymap = "gh",
            save_chat_keymap = "sc",
            auto_save = true,
            expiration_days = 0,
            picker = "snacks",
            auto_generate_title = true,
            continue_last_chat = false,
            delete_on_clearing_chat = false,
            title_generation_opts = {},
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
            prompt_library = {
              ["CodeCompanion Assistant"] = {
                project_root = plugin.dir,
                file_patterns = { "lua/codecompanion/**.lua", "doc/**/*.md" },
              },
              ["Kitty Assistant"] = {
                project_root = "/usr/share/doc/kitty/",
                file_patterns = { "**/*.txt" },
              },
              ["Arch Wiki"] = {
                project_root = "/usr/share/doc/arch-wiki/",
                file_patterns = { "/usr/share/doc/arch-wiki/html/en/**/*.html" },
              },
            },
            tool_group = { collapse = true },
            tool_opts = {
              ["*"] = { use_lsp = true },
              ls = {},
              vectorise = {},
              ---@type VectorCode.CodeCompanion.QueryToolOpts
              query = {
                default_num = { document = 5, chunk = 10 },
                max_num = { document = 10, chunk = 20 },
                chunk_mode = true,
                summarise = {
                  enabled = false,
                  adapter = function()
                    return require("codecompanion.adapters.http").extend("gemini", {
                      name = "Summariser",
                      schema = {
                        model = { default = "gemini-2.0-flash-lite" },
                      },
                      opts = { stream = false },
                    })
                  end,
                  query_augmented = true,
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
            ---@type string|fun(adapter: CodeCompanion.HTTPAdapter|CodeCompanion.ACPAdapter): string
            llm = function(adapter)
              if adapter.model then
                return string.format(
                  "%s (%s)",
                  adapter.formatted_name,
                  adapter.model.name
                )
              else
                return adapter.formatted_name
              end
            end,
          },
          tools = {
            opts = {
              -- default_tools = { "vectorcode_toolbox", "file_search", "read_file" },
            },
          },
          opts = {

            ---@param ctx CodeCompanion.SystemPrompt.Context
            system_prompt = function(ctx)
              return ctx.default_system_prompt
                .. string.format(
                  [[Extra information:
- current project that you're working on: %s
- current operating system: %s
]],
                  ctx.project_root or ctx.cwd,
                  ctx.os
                )
            end,
          },
        },
        inline = {
          adapter = "Gemini",
        },
      }

      if os.getenv("SILICONFLOW_API_KEY") then
        opts.adapters.http["SiliconFlow"] = function()
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
        opts.adapters.http["Qwen"] = function()
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
      return require("_utils").no_vscode()
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
    opts = function(_, opts)
      ---@type VectorCode.Opts
      return vim.tbl_deep_extend("force", opts or {}, {
        async_backend = "lsp",
        notify = true,
        on_setup = { lsp = true },
        n_query = 10,
        cli_cmds = { vectorcode = vim.fs.normalize("~/.local/bin/vectorcode") },
        timeout_ms = -1,
        async_opts = {
          events = { "BufWritePost" },
          single_job = true,
          query_cb = require("vectorcode.utils").make_surrounding_lines_cb(40),
          debounce = -1,
          n_query = 30,
        },
      })
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
      return vim.fn.executable("vectorcode") == 1 and require("_utils").no_vscode()
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
        extensions = { copilotchat = { enabled = false } },
      }
    end,
  },
  {
    "milanglacier/minuet-ai.nvim",
    cond = require("_utils").no_vscode,
    event = "VeryLazy",
    config = function(_, opts)
      local num_docs = 10
      opts = {
        add_single_line_entry = true,
        n_completions = 1,
        after_cursor_filter_length = 0,
        provider = "openai_fim_compatible",
        provider_options = {
          openai_fim_compatible = {
            api_key = "LLAMACPP_API_KEY",
            name = "llama.cpp",
            end_point = "http://localhost:8080/v1/completions",
            model = "qwen3-coder-30b-a3b",
            optional = { max_tokens = 100 },
            stream = false,
            template = {
              prompt = function(prefix, suffix, _)
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

                  if git_diff then
                    local recent_commits = recent_commits_job:wait().stdout
                    local curr_branch = vim.trim(curr_branch_job:wait().stdout)
                    local prompt = "<|fim_prefix|>"
                    if curr_branch then
                      prompt = prompt
                        .. string.format(
                          "<|file_sep|>The current branch name is `%s`\n",
                          curr_branch
                        )
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
                      .. "<|fim_prefix|>"
                      .. prefix
                      .. "<|fim_suffix|>"
                      .. suffix
                      .. "<|fim_middle|>"
                  end
                end
                local prompt = "<|fim_prefix|>"
                  .. prefix
                  .. "<|fim_suffix|>"
                  .. suffix
                  .. "<|fim_middle|>"
                local has_vc, vectorcode_config = pcall(require, "vectorcode.config")
                if has_vc then
                  prompt = vectorcode_config
                    .get_cacher_backend()
                    .make_prompt_component(0, function(file)
                      return "<|file_separator|>" .. file.path .. "\n" .. file.document
                    end).content .. prompt
                end

                return prompt
              end,
              suffix = false,
            },
          },
          gemini = {
            model = "gemini-2.0-flash",
            api_key = "GEMINI_API_KEY",
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

      require("minuet").setup(opts)

      -- local num_ctx = 1024 * 32
      -- local openai_fim_compatible = require("minuet.backends.openai_fim_compatible")
      -- local orig_get_text_fn = openai_fim_compatible.get_text_fn
      -- openai_fim_compatible.get_text_fn = function(json)
      --   local bufnr = vim.api.nvim_get_current_buf()
      --   vim.b[bufnr].ai_raw_response = json
      --   local has_vc, vectorcode_config = pcall(require, "vectorcode.config")
      --   if not has_vc then
      --     return
      --   end
      --   if vectorcode_config.get_cacher_backend().buf_is_registered() then
      --     local new_num_query = num_docs
      --     if json.usage.total_tokens > num_ctx then
      --       new_num_query = math.max(num_docs - 1, 1)
      --     elseif json.usage.total_tokens < num_ctx * 0.9 then
      --       new_num_query = num_docs + 1
      --     end
      --     vectorcode_config
      --       .get_cacher_backend()
      --       .register_buffer(0, { n_query = new_num_query })
      --   end
      --   return orig_get_text_fn(json)
      -- end
    end,
  },
}
