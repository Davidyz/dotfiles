local os = require("os")
local api = vim.api
local co = require("coroutine")

local M = {}

HOME = os.getenv("HOME")

SOURCE_CODE = {
  "java",
  "c",
  "cpp",
  "python",
  "hs",
  "sh",
  "go",
  "php",
  "json",
  "bash",
  "zsh",
  "vim",
  "lua",
  "make",
}
TEXT = { "md", "txt", "markdown", "rmd", "pandoc", "text", "tex" }

M.gitModified = function()
  local files = nil
  if vim.fn.has("unix") then
    files = vim.fn.systemlist("git ls-files -m 2> /dev/null")
  else
    files = vim.fn.systemlist("git ls-files -m")
  end
  if files then
    return vim.fn.map(files, "{'line': v:val, 'path': v:val}")
  end
end

M.gitUntracked = function()
  local files = nil
  if vim.fn.has("unix") then
    files = vim.fn.systemlist("git ls-files -o --exclude-standard 2> /dev/null")
  else
    files = vim.fn.systemlist("git ls-files -o --exclude-standard")
  end
  if files then
    return vim.fn.map(files, "{'line': v:val, 'path': v:val}")
  end
end

---@param array table
---@return boolean
function M.contains(array, element)
  for _, value in pairs(array) do
    if value == element then
      return true
    end
  end
  return false
end

---@param filetype
---@return boolean
function M.isSourceCode(filetype)
  return M.contains(SOURCE_CODE, filetype)
end

---@return string
function M.getHostname()
  if vim.fn.hostname ~= nil then
    return vim.fn.hostname()
  end
  return ""
end

---@return string
function M.getUserName()
  local username = vim.fn.getenv("USER")
  if username == nil then
    username = vim.fn.getenv("USERNAME")
  end
  return username
end

function M.get_ColorCode(group, tag)
  return vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID(group)), tag)
end

---@param str string
function M.getTermCode(str)
  return api.nvim_replace_termcodes(str, true, true, true)
end

function M.sendKey(str, mode, escape)
  if escape == nil then
    escape = false
  end
  return api.nvim_feedkeys(str, mode, escape)
end

---@param item string
function M.Require(item)
  if not type(item) == "string" then
    return false
  end
  local status, error_message = pcall(require, item)
  if not status then
    print(error_message)
  end
  return status
end

---@param items string[]
---@param retry_count? integer
function M.tryRequire(items, retry_count)
  if retry_count == 0 then
    vim.o.cmdheight = #items + 1
    api.nvim_echo({ { "Failed to require the following files:", "None" } }, false, {})
    for _, item in ipairs(items) do
      api.nvim_echo({ { item, "None" } }, false, {})
    end
    return
  end
  retry_count = retry_count or 10
  local failed = {}
  for _, item in ipairs(items) do
    local status = M.Require(item)
    if not status then
      table.insert(failed, item)
    end
  end
  if #failed > 0 then
    M.tryRequire(failed, retry_count - 1)
  end
end

---@param array table
---@param func function
---@return boolean
function M.any(array, func)
  if type(func) ~= "function" then
    func = function(item)
      return item
    end
  end
  for i, item in ipairs(array) do
    if func(item) then
      return true
    end
  end
  return false
end

---@param array table
---@param func function
---@return boolean
function M.all(array, func)
  if type(func) ~= "function" then
    func = function(item)
      return item
    end
  end
  for i, item in ipairs(array) do
    if not func(item) then
      return false
    end
  end
  return true
end

---@param func function
---@param callback function
M.async_run = function(func, callback)
  assert(type(func) == "function", "type error :: expected func")
  local thread = co.create(func)
  local step = nil
  step = function(...)
    local stat, ret = co.resume(thread, ...)
    assert(stat, ret)
    if co.status(thread) == "dead" then
      (callback or function(arg) end)(ret)
    else
      assert(type(ret) == "function", "type error :: expected func")
      ret(step)
    end
  end
  step()
end

---@return integer
M.cpu_count = function()
  if vim.uv == nil or vim.uv.cpu_info == nil then
    return #vim.loop.cpu_info()
  end
  return #vim.uv.cpu_info()
end

---@return integer
M.line_length = function()
  if vim.bo.textwidth == 0 then
    return nil
  else
    return vim.bo.textwidth
  end
end

---@return boolean
M.no_vscode = function()
  return vim.g.vscode == nil
end

M.no_neovide = function()
  return vim.fn.exists("g:neovide") ~= 1
end

---@return boolean
M.is_treesitter_enabled = function()
  local okay, parsers = pcall(require, "nvim-treesitter.parsers")
  if not okay then
    return false
  end
  local lang = parsers.get_buf_lang()
  return parsers.has_parser(lang)
end

---@return Range4
M.has_selection = function()
  local mode = vim.fn.mode()
  if mode == "v" or mode == "V" or mode == "\22" then -- Normal, Line, or Block visual mode
    local mark_start = api.nvim_buf_get_mark(0, "<")
    local mark_end = api.nvim_buf_get_mark(0, ">")

    if mark_start[1] ~= mark_end[1] or mark_start[2] ~= mark_end[2] then
      return {
        mark_start[1],
        mark_start[2],
        mark_end[1],
        mark_end[2],
      }
    end
  end
  return nil
end

---@return 'linux'|'mac'|'win'|'unknown'
M.platform = function()
  if vim.fn.has("linux") == 1 then
    return "linux"
  elseif vim.fn.has("mac") == 1 then
    return "mac"
  elseif vim.fn.has("win32") == 1 then
    return "win"
  else
    return "unknown"
  end
end

---@return boolean
function M.is_basic_ssh()
  return vim.fn.environ()["FANCY_TERM"] == nil
    and vim.fn.environ()["SSH_CONNECTION"] ~= nil
end

M.codicons = {
  Array = "  ",
  Boolean = "  ",
  Class = "  ",
  Clipboard = "  ",
  Color = "  ",
  Constant = "  ",
  Constructor = "  ",
  Enum = "  ",
  EnumMember = "  ",
  Event = "  ",
  Field = "  ",
  File = "  ",
  Folder = "  ",
  Function = "  ",
  Interface = "  ",
  Key = "  ",
  Keyword = "  ",
  Method = "  ",
  Module = "  ",
  Namespace = "  ",
  Null = "  ",
  Number = "  ",
  Object = "  ",
  Operator = "  ",
  Package = "  ",
  Property = "  ",
  Reference = "  ",
  Snippet = "  ",
  String = "  ",
  Struct = "  ",
  Text = "  ",
  TypeParameter = "  ",
  Unit = "  ",
  Value = "  ",
  Variable = "  ",
}

M.mason_packages = {
  "actionlint",
  "basedpyright",
  "bash-language-server",
  "clang-format",
  "clangd",
  "clangd",
  "debugpy",
  "editorconfig-checker",
  "harper-ls",
  "html-lsp",
  "jsonls",
  "lua-language-server",
  "prettierd",
  "ruff",
  "shellcheck",
  "shfmt",
  "stylua",
  "taplo",
  "ty",
  "tree-sitter-cli",
  "vim-language-server",
  "yaml-language-server",
}

M.treesitter_parsers = {
  "python",
  "c",
  "comment",
  "cpp",
  "gitcommit",
  "javascript",
  "json5",
  "make",
  "regex",
  "lua",
  "luadoc",
  "regex",
  "toml",
  "markdown_inline",
  "vim",
  "yaml",
  "vimdoc",
  "git_rebase",
  "gitattributes",
}

local conditionals = {
  ["arduino-cli"] = "arduino-language-server",
  arduino = "arduino-language-server",
  cmake = { "cmakelang", "cmake-language-server" },
  docker = { "dockerfile-language-server", "docker-compose-language-service" },
  javac = "jdtls",
  node = { "typescript-language-server" },
  pdflatex = { "texlab", "latexindent" },
  rustc = "rust-analyzer",
  tex = "texlab",
}

for exe, ls in pairs(conditionals) do
  if vim.fn.executable(exe) ~= 0 then
    if type(ls) == "string" then
      table.insert(M.mason_packages, ls)
    elseif type(ls) == "table" then
      vim.list_extend(M.mason_packages, ls)
    end
  end
end

---@param opts {bufnr: integer?, methods: string|string[]|nil, strategy: "all"|"any"|nil}
---@return vim.lsp.Client[]
function M.get_lsp_clients(opts)
  return vim
    .iter(vim.lsp.get_clients({ bufnr = opts.bufnr }))
    :filter(
      ---@param cli vim.lsp.Client
      function(cli)
        if opts.methods == nil then
          -- no constraint
          return true
        elseif type(opts.methods) == "string" then
          -- same as `vim.lsp.get_clients`
          return cli:supports_method(tostring(opts.methods), opts.bufnr)
        else
          local iter = vim.iter(opts.methods)
          local strategy = opts.strategy or "any"
          assert(strategy == "any" or strategy == "all")
          return iter[strategy](
            iter,
            ---@param method string
            function(method)
              return cli:supports_method(method, opts.bufnr)
            end
          )
        end
      end
    )
    :totable()
end

---@param t number
---@return string
function M.make_display_time(t)
  local curr_time = assert(vim.uv.clock_gettime("realtime"))
  local now = curr_time.nsec / 1e9 + curr_time.sec

  local total_seconds = math.floor((now - t))

  local digits = {}
  while total_seconds > 0 do
    table.insert(digits, 1, total_seconds % 60)
    total_seconds = math.floor(total_seconds / 60)
  end

  if #digits == 1 then
    return string.format("%ds", digits[1])
  end
  digits = vim
    .iter(digits)
    :map(function(d)
      if d < 10 then
        return "0" .. tostring(d)
      else
        return tostring(d)
      end
    end)
    :totable()
  return table.concat(digits, ":")
end

---@param opts {level?: string}
function M.close_no_diagnostics(opts)
  opts = opts or {}

  ---@param level string
  local function run(level)
    level = string.upper(level)
    local buffers = vim
      .iter(api.nvim_list_bufs())
      :filter(
        ---@param bufnr integer
        function(bufnr)
          local stat = vim.uv.fs_stat(vim.uri_to_fname(vim.uri_from_bufnr(bufnr)))
          return stat ~= nil and stat.type == "file"
        end
      )
      :filter(
        ---@param bufnr integer
        function(bufnr)
          local diags_levels = vim
            .iter(vim.diagnostic.get(bufnr))
            :map(
              ---@param d vim.Diagnostic
              function(d)
                return d.severity or 4
              end
            )
            :totable()
          if #diags_levels == 0 then
            return true
          end
          local most_serious = math.min(unpack(diags_levels))
          return most_serious > vim.diagnostic.severity[level]
        end
      )
      :totable()
    for _, bufnr in ipairs(buffers) do
      api.nvim_buf_delete(bufnr, {})
    end
    vim.notify(string.format("Closed %d buffers.", #buffers))
  end
  if opts.level ~= nil then
    run(opts.level)
  else
    vim.ui.select(
      { "ERROR", "WARN", "INFO", "HINT" },
      { prompt = "Diagnostic Filter LEvel" },
      function(item, _)
        item = item or "WARN"
        run(item)
      end
    )
  end
end

api.nvim_create_user_command("CloseHealthyBufs", function(args)
  ---@type string?
  local level = args.args
  if level == "" then
    level = nil
  end
  M.close_no_diagnostics({ level = level })
end, {
  complete = function(_, _, _)
    return { "ERROR", "WARN", "INFO", "HINT" }
  end,
  nargs = "?",
})

return M
