local utils = require("utils")

local gps = require("nvim-gps")

local function file_path()
  return vim.api.nvim_buf_get_name(0):gsub(os.getenv("HOME"), "~")
end

local function devicon()
  return string.sub(require("nvim-web-devicons").get_icon(vim.fn.expand("%"), vim.fn.expand("%:e"), {}), 1)
end

local function get_context()
  return utils.getUserName() .. "@" .. utils.getHostname()
end

local function is_text()
  return vim.tbl_contains(TEXT, vim.bo.filetype)
end

local function wordCount()
  local wc = vim.api.nvim_eval("wordcount()")
  if wc["visual_words"] then
    return "wc: " .. tostring(wc["visual_words"])
  else
    return "wc: " .. tostring(wc["words"])
  end
end

require("lualine").setup({
  options = {
    icons_enabled = true,
    theme = "onedarkpro",
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
      {
        gps.get_location,
        cond = gps.is_available,
      },
    },
    lualine_x = { "encoding", "fileformat" },
    lualine_y = { "progress" },
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
        max_length = vim.o.columns,
      },
    },
  },
  extensions = {},
})
