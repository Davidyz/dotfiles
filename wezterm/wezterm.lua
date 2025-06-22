---@type Wezterm
local wezterm = require("wezterm")

local using_polonium = false
if os.getenv("HAS_POLONIUM") then
  using_polonium = true
end

---@param path string
---@return boolean
local function exists(path)
  local ok, err, code = os.rename(path, path)
  if not ok then
    if code == 13 then
      -- Permission denied, but it exists
      return true
    end
    return false
  end
  return true
end

---@diagnostic disable-next-line: missing-fields
local config = {}
if wezterm.config_builder then
  config = wezterm.config_builder()
end

config.front_end = "OpenGL"
-- for _, gpu in ipairs(wezterm.gui.enumerate_gpus()) do
--   if gpu.backend == "Vulkan" then
--     config.webgpu_preferred_adapter = gpu
--     config.front_end = "WebGpu"
--     break
--   end
-- end

local color = wezterm.color.get_builtin_schemes()["Catppuccin Mocha"]

local function deepcopy(orig)
  local copy
  if type(orig) == "table" then
    copy = {}
    for orig_key, orig_value in next, orig, nil do
      copy[deepcopy(orig_key)] = deepcopy(orig_value)
    end
    setmetatable(copy, deepcopy(getmetatable(orig)))
  else -- number, string, boolean, etc
    copy = orig
  end
  return copy
end
color.split = "#b3bdfe"
for i = 1, 8 do
  -- NOTE: make `bright` colors actually brighter
  color.ansi[i] = wezterm.color.parse(color.ansi[i])
  color.brights[i] = wezterm.color.parse(color.brights[i])
  if color.ansi[i] == color.brights[i] then
    color.brights[i] = color.brights[i]:lighten(0.3)
    -- color.ansi[i] = wezterm.color.parse(color.brights[i]):darken(0.1)
  end
end

color.cursor_bg = color.ansi[5]
color.cursor_border = color.ansi[5]
color.tab_bar.inactive_tab.bg_color = color.background
color.tab_bar.active_tab.bg_color = color.split
color.tab_bar.inactive_tab.fg_color = color.split

config.status_update_interval = 1
wezterm.on("update-status", function(window, pane)
  -- changes color of sudo lock glyph when the window is not focused.
  local mux_window = window:mux_window()
  local meta = pane:get_metadata() or {}
  local overrides = { colors = deepcopy(color) }
  if meta.password_input then
    if not window:is_focused() then
      overrides.colors.cursor_border = color.ansi[2]
      overrides.colors.cursor_bg = color.ansi[2]
    end
  else
    if not window:is_focused() then
      overrides.colors.cursor_border = color.ansi[3]
      overrides.colors.cursor_bg = color.ansi[3]
    end
  end
  window:set_config_overrides(overrides)
end)
config.colors = color

if using_polonium then
  config.window_frame = {
    active_titlebar_bg = color.background,
    button_bg = color.background,
    button_fg = color.foreground,
    button_hover_bg = color.selection_bg,
    button_hover_fg = color.selection_fg,
    inactive_titlebar_bg = color.background,
  }
  config.window_padding = {
    left = "1cell",
    right = "1cell",
    top = 0,
    bottom = 0,
  }
else
  config.window_frame = {
    active_titlebar_bg = color.background,
    button_bg = color.background,
    button_fg = color.foreground,
    button_hover_bg = color.selection_bg,
    button_hover_fg = color.selection_fg,
    inactive_titlebar_bg = color.background,

    border_left_width = "0.2cell",
    border_right_width = "0.2cell",
    border_bottom_height = "0.1cell",
    border_top_height = "0.1cell",
    border_left_color = color.ansi[1],
    border_right_color = color.ansi[1],
    border_bottom_color = color.ansi[1],
    border_top_color = color.ansi[1],
  }
end

config.show_new_tab_button_in_tab_bar = false
config.switch_to_last_active_tab_when_closing_tab = true
if config.show_close_tab_button_in_tabs ~= nil then
  config.show_close_tab_button_in_tabs = false
end

config.enable_scroll_bar = true
config.font = wezterm.font_with_fallback({
  "Maple Mono Normal NL NF CN",
  "Cascadia Mono",
  "Symbols Nerd Font Mono",
  "codicon",
  "Noto Sans Mono",
  "Noto Sans Mono CJK SC",
})
config.font_size = 11.5
config.cell_width = 0.95
config.line_height = 0.975
config.harfbuzz_features = { "calt=0", "clig=0", "liga=0" }
config.inactive_pane_hsb = {
  saturation = 0.7,
  brightness = 0.7,
}

local action = wezterm.action
config.keys = {
  {
    key = "PageUp",
    mods = "CTRL",
    action = action.DisableDefaultAssignment,
  },
  {
    key = "PageDown",
    mods = "CTRL",
    action = action.DisableDefaultAssignment,
  },
  {
    key = "Space",
    mods = "CTRL",
    action = action.DisableDefaultAssignment,
  },
  {
    key = "PageUp",
    mods = "CTRL|SHIFT",
    action = action.DisableDefaultAssignment,
  },
  {
    key = "PageDown",
    mods = "CTRL|SHIFT",
    action = action.DisableDefaultAssignment,
  },
  {
    key = "f",
    mods = "CTRL|SHIFT",
    action = action.DisableDefaultAssignment,
  },
  { key = "PageUp", mods = "ALT", action = action.ActivateTabRelative(-1) },
  { key = "PageDown", mods = "ALT", action = action.ActivateTabRelative(1) },
  {
    key = "t",
    mods = "ALT",
    action = action.SpawnTab("CurrentPaneDomain"),
  },
  { key = "PageUp", mods = "ALT|SHIFT", action = action.MoveTabRelative(-1) },
  { key = "PageDown", mods = "ALT|SHIFT", action = action.MoveTabRelative(1) },
  {
    key = "w",
    mods = "ALT",
    action = action.CloseCurrentTab({ confirm = false }),
  },
  { key = "F11", mods = "ALT", action = action.ToggleFullScreen },
  { key = "+", mods = "CTRL", action = action.IncreaseFontSize },
  { key = "-", mods = "CTRL", action = action.DecreaseFontSize },
  { key = "0", mods = "CTRL", action = action.ResetFontSize },
  { key = "C", mods = "CTRL|SHIFT", action = action.CopyTo("Clipboard") },
  { key = "V", mods = "CTRL|SHIFT", action = action.PasteFrom("Clipboard") },
  { key = "=", mods = "ALT", action = action.ScrollByLine(1) },
  { key = "-", mods = "ALT", action = action.ScrollByLine(-1) },
  { key = "_", mods = "ALT|SHIFT", action = action.ScrollByPage(-1) },
  { key = "+", mods = "ALT|SHIFT", action = action.ScrollByPage(1) },
  { key = "s", mods = "ALT", action = action.ShowLauncher },
}
for i = 1, 9 do
  -- F1 through F9 to activate that tab
  table.insert(config.keys, {
    key = tostring(i),
    mods = "ALT",
    action = action.ActivateTab(i - 1),
  })
end
if not using_polonium then
  wezterm.on("gui-startup", function(cmd)
    local tab, pane, window = wezterm.mux.spawn_window(cmd or {})
    window:gui_window():maximize()
  end)
end

if string.find(wezterm.target_triple, "windows") ~= nil then
  config.default_prog = {
    -- (os.getenv("SystemRoot") or "C:\\Windows\\")
    --   .. "\\System32\\WindowsPowerShell\\v1.0\\powershell.exe",
    -- "-NoLogo",
    "pwsh",
  }
elseif string.find(wezterm.target_triple, "linux") ~= nil then
  config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"
end

config.hide_tab_bar_if_only_one_tab = true
return config
