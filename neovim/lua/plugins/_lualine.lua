local utils = require("_utils")
local nvim_devicon = require("nvim-web-devicons")

vim.opt.laststatus = 3

local function get_devicon_for_buf()
  local full_name = vim.fn.expand("%") or ""
  if full_name == "" or full_name == nil then
    return ""
  end
  local ft_name = vim.fn.expand("%:e") or ""
  if ft_name == "" or ft_name == nil then
    return ""
  end
  local icon = nvim_devicon.get_icon(full_name, ft_name, {}) or ""
  return string.sub(icon, 1)
end

local function get_context()
  local user = utils.getUserName()
  local hostname = utils.getHostname()
  local result = ""
  if user and hostname then
    result = user .. " " .. hostname
  elseif user or hostname then
    result = user or hostname
  end
  if vim.bo.filetype == "startify" and result ~= "" then
    result = result
      .. ": v"
      .. tostring(vim.version().major)
      .. "."
      .. tostring(vim.version().minor)
      .. "."
      .. tostring(vim.version().patch)
  end
  return result
end

local function is_text()
  return vim.tbl_contains(TEXT, vim.bo.filetype)
end

local function wordCount()
  if vim.bo.ft == "tex" and vim.fn["vimtex#misc#wordcount"] then
    local nerd_icon = nvim_devicon.get_icon_by_filetype("tex")
    local opts = { detailed = 1, count_letters = 0 }
    vim.g.vimtex_texcount_custom_arg = "-ch -jp -kr "
    local lines = vim
      .iter(vim.fn["vimtex#misc#wordcount"](opts))
      :filter(function(line)
        return string.find(line, "^Sum") ~= nil
      end)
      :totable()
    return nerd_icon .. " : " .. string.match(lines[1], "%d+")
  end

  local wc = vim.fn["wordcount"]()
  if wc.visual_words ~= nil then
    return "wc: " .. tostring(wc.visual_words)
  else
    return "wc: " .. tostring(wc.words)
  end
end

local function arduino_status()
  if vim.bo.filetype ~= "arduino" then
    return ""
  end
  local port = vim.fn["arduino#GetPort"]()
  local line = string.format("[%s]", vim.g.arduino_board)
  if vim.g.arduino_programmer ~= "" then
    line = line .. string.format(" [%s]", vim.g.arduino_programmer)
  end
  if port ~= 0 then
    line = line .. string.format(" (%s:%s)", port, vim.g.arduino_serial_baud)
  end
  return line
end

local snacks_status_component = require("snacks").profiler.status()

local diffview_label = function()
  if package.loaded["diffview"] ~= nil then
    ---@module 'diffview'

    local view = require("diffview.lib").get_current_view()
    local bufnr = vim.api.nvim_get_current_buf()
    local rev_label = ""
    local path = ""
    for _, file in ipairs(view.cur_entry and view.cur_entry.layout:files() or {}) do
      if file:is_valid() and file.bufnr == bufnr then
        path = string.format("%s/%s", view.adapter.ctx.toplevel, file.path)
        local rev = file.rev
        if rev.type == 1 then
          rev_label = "LOCAL"
        elseif rev.type == 2 then
          local head =
            vim.trim(vim.fn.system({ "git", "rev-parse", "--revs-only", "HEAD" }))
          if head == rev.commit then
            rev_label = "HEAD"
          else
            rev_label = string.format("%s", rev.commit:sub(1, 7))
          end
        elseif rev.type == 3 then
          rev_label = ({
            [0] = "INDEX",
            [1] = "MERGE COMMON ANCESTOR",
            [2] = "MERGE OURS",
            [3] = "MERGE THEIRS",
          })[rev.stage] or ""
        end
      end
    end
    if rev_label ~= "" then
      return string.format("DiffView %s", rev_label)
    end
  end
  return ""
end

local lualine_config = {
  options = {
    icons_enabled = true,
    theme = "auto",
    section_separators = { left = "", right = "" },
    component_separators = { left = "", right = "" },
    disabled_filetypes = {},
    globalstatus = true,
  },
  sections = {
    lualine_a = { { "mode" } },
    lualine_b = {
      "branch",
      "diff",
      {
        "diagnostics",
        sources = { "nvim_lsp" },
      },
    },
    lualine_c = {
      get_context,
      { "filename", path = 3 },
    },
    lualine_x = { { "searchcount" }, { "progress" } },
    lualine_y = {
      {
        "encoding",
        padding = { left = 1, right = 0 },
        separator = "",
      },
      "fileformat",
    },
    lualine_z = {
      {
        wordCount,
        cond = is_text,
      },
      { "location" },
    },
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { "filename" },
    lualine_x = { "location" },
    lualine_y = {},
    lualine_z = {},
  },
  tabline = {
    lualine_b = {
      {
        "tabs",
        mode = 1,
        max_length = function()
          return vim.o.columns - 40
        end,
        path = 1,
        show_modified_status = true, -- Shows a symbol next to the tab name if the file has been modified.
        symbols = {
          modified = "[+]", -- Text to show when the file is modified.
        },

        fmt = function(name, _)
          local ft_icon = get_devicon_for_buf()
          if ft_icon ~= "" then
            return ft_icon .. " " .. name
          else
            return name
          end
        end,
        use_mode_colors = true,
      },
    },
    lualine_y = {
      {
        diffview_label,
        cond = function()
          return package.loaded["diffview"] ~= nil
        end,
      },
      {
        function()
          return require("vectorcode.integrations").lualine()[1]()
        end,
        cond = function()
          if package.loaded["vectorcode"] == nil then
            return false
          else
            return require("vectorcode.integrations").lualine().cond()
          end
        end,
      },
    },
    lualine_z = {
      {
        function()
          local response = vim.b.ai_raw_response
          return string.format("ctx: %d", response.usage.total_tokens)
        end,
        cond = function()
          return vim.b.ai_raw_response ~= nil
        end,
      },
    },
  },
  winbar = {
    lualine_b = {
      {
        "navic",
        color_correction = "dynamic",
        navic_opts = {
          icons = require("_utils").codicons,
          separator = "   ",
        },
        cond = function()
          return package.loaded["nvim-navic"] ~= nil
            and require("nvim-navic").is_available()
        end,
      },
    },
    lualine_y = {
      {
        function()
          if vim.bo.filetype == "arduino" then
            return arduino_status()
          elseif vim.bo.filetype == "python" then
            return string.gsub(require("venv-selector").venv(), os.getenv("HOME"), "~")
              or ""
          end
        end,
        cond = function()
          return vim.list_contains({ "arduino", "python" }, vim.bo.filetype)
        end,
      },
    },
    lualine_z = { snacks_status_component },
  },
  extensions = {
    "overseer",
    "lazy",
    "mason",
    "man",
    "oil",
    "neo-tree",
    "toggleterm",
    "nvim-dap-ui",
  },
}
require("lualine").setup(lualine_config)
