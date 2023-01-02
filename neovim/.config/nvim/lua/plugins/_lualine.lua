local utils = require("_utils")
local nvim_devicon = require("nvim-web-devicons")

if not nvim_devicon.has_loaded() then
  nvim_devicon.setup()
end

local function file_path()
  return vim.api.nvim_buf_get_name(0):gsub(os.getenv("HOME"), "~")
end

local function devicon()
  return string.sub(nvim_devicon.get_icon(vim.fn.expand("%"), vim.fn.expand("%:e"), {}), 1)
end

local function get_context()
  local user = utils.getUserName()
  local hostname = utils.getHostname()
  if user and hostname then
    return user .. "@" .. hostname
  elseif user or hostname then
    return user or hostname
  end
end

local function is_text()
  return vim.tbl_contains(TEXT, vim.bo.filetype)
end

local function wordCount()
  if type(vim.b.latex_wc) == "string" then
    return ("wc: " .. vim.b.latex_wc) or ""
  end

  local wc = vim.fn["wordcount"]()
  if wc.visual_words ~= nil then
    return "wc: " .. tostring(wc.visual_words)
  else
    return "wc: " .. tostring(wc.words)
  end
end

require("lualine").setup({
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
        sources = { "coc" },
      },
      devicon,
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
        "tabs",
        mode = 2,
      },
    },
  },
  extensions = {},
})
