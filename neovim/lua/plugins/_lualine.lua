local utils = require("_utils")
local nvim_devicon = require("nvim-web-devicons")


local function file_path()
  return vim.api.nvim_buf_get_name(0):gsub(os.getenv("HOME"), "~")
end

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
    result = user .. "@" .. hostname
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
    local nerd_icon = nvim_devicon.get_icon_by_filetype('tex')
    local opts = { detailed = 0, count_letters = 0 }
    local selection_range = utils.has_selection()
    if selection_range == nil then
      return "wc" .. nerd_icon .. " : " .. tostring(vim.fn["vimtex#misc#wordcount"](opts))
    else
      opts.range = { selection_range[1], selection_range[3] }
      return "wc" .. nerd_icon .. " : " .. tostring(vim.fn["vimtex#misc#wordcount"](opts))
    end
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

local lualine_config = {
  options = {
    icons_enabled = true,
    theme = "auto",
    component_separators = { left = "", right = "" },
    section_separators = { left = "", right = "" },
    disabled_filetypes = {},
    always_divide_middle = true,
  },
  sections = {
    lualine_a = { "mode" },
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
      file_path,
    },
    lualine_x = { "progress" },
    lualine_y = { "encoding", "fileformat" },
    lualine_z = {
      "location",
      {
        wordCount,
        cond = is_text,
      },
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
        max_length = vim.o.columns,
        "tabs",
        mode = 2,
        fmt = function(str)
          local ft_icon = get_devicon_for_buf()
          if ft_icon ~= "" then
            return ft_icon .. " " .. str
          else
            return str
          end
        end,
      },
    },
    lualine_y = { { "navic", color_correction = "dynamic" } },
    lualine_z = {
      {
        arduino_status,
        cond = function()
          return vim.bo.filetype == "arduino"
        end,
      },
    },
  },
  extensions = {},
}
require("lualine").setup(lualine_config)
