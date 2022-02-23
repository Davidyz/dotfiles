require('utils')

local gps = require('nvim-gps')
local current_theme = require('lualine.themes.auto')
local function get_mode_theme()
  if vim.api.nvim_get_mode() == 'n' then
    return current_theme.normal
  elseif vim.api.nvim_get_mode() == 'i' then
    return current_theme.insert
  elseif vim.api.nvim_get_mode() == 'v' then
    return current_theme.visual
  elseif vim.api.nvim_get_mode() == 'r' then
    return current_theme.replace
  else
    return current_theme.normal
  end
end


local function file_path()
  return vim.api.nvim_buf_get_name(0):gsub(os.getenv('HOME'), '~')
end

local function word_count()
  if not vim.tbl_contains(TEXT, vim.bo.filetype) then return "" end
  local wc = vim.fn.wordcount()['words']
  if wc >= 0 then return "wc: " .. tostring(wc) end
  return ""
end

local function devicon()
  return string.sub(
    require('nvim-web-devicons').get_icon(vim.fn.expand('%'), vim.fn.expand('%:e'), {}),
    1
  )
end

local function get_context()
  return GetUserName() .. "@" .. GetHostname()
end

local function is_text()
  return vim.tbl_contains(TEXT, vim.bo.filetype)
end

require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = 'auto',
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
    disabled_filetypes = {},
    always_divide_middle = true,
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff', 'diagnostics', devicon},
    lualine_c = {
      get_context,
      file_path,
      {
        gps.get_location,
        cond = gps.is_available
      }
    },
    lualine_x = {'encoding', 'fileformat'},
    lualine_y = {'progress'},
    lualine_z = {
      'location',
      {
        word_count,
        cond = is_text
      }
    },
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {
    lualine_b = {
      {
        'tabs',
        max_length = vim.o.columns / 3,
        mode=2,
        tabs_color = {
          active = {
            fg = current_theme.normal.b.fg,
            bg = current_theme.normal.b.bg
          },
          inactive = {
            fg = current_theme.normal.c.fg,
            bg = current_theme.normal.c.bg
          }
        }
      }
    }
  },
  extensions = {}
}
