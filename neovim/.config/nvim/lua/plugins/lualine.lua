require('utils')

local gps = require('nvim-gps')

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
      file_path,
      {
        gps.get_location,
        cond = gps.is_available
      }
    },
    lualine_x = {'encoding', 'fileformat'},
    lualine_y = {'progress'},
    lualine_z = {'location', word_count}
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
      {'tabs', max_length=99, mode=2, tabs_color = {active = {fg = '#FFCC66', bg = '#1A1F29'}}}
    }
  },
  extensions = {}
}
