---@type Wezterm
local wezterm = require("wezterm")

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
for _, gpu in ipairs(wezterm.gui.enumerate_gpus()) do
  if gpu.backend == "Vulkan" then
    config.webgpu_preferred_adapter = gpu
    config.front_end = "WebGpu"
    break
  end
end

-- config.color_scheme = "Catppuccin Mocha"

local color = wezterm.color.get_builtin_schemes()["Catppuccin Mocha"]

for i = 1, 8 do
  color.ansi[i] = wezterm.color.parse(color.ansi[i])
  color.brights[i] = wezterm.color.parse(color.brights[i])
  if color.ansi[i] == color.brights[i] then
    color.brights[i] = color.brights[i]:lighten(0.3)
    -- color.ansi[i] = wezterm.color.parse(color.brights[i]):darken(0.1)
  end
end

config.colors = color

wezterm.on("format-tab-title", function(tab, tabs, _panes, conf, _hover, _max_width)
  local title = ("%s: %s").format(tab.panes_with_info().index, tab.active_pane.title)
  local s_bg = color.ansi[5]
  local s_fg = color.cursor_fg
  if not tab.is_active then
    s_bg = color.background
    s_fg = color.selection_bg
  end
  local e_bg = color.background
  local e_fg = color.foreground
  return {
    { Background = { Color = s_bg } },
    { Foreground = { Color = s_fg } },
    { Text = title },
    -- { Background = { Color = e_bg } },
    -- { Foreground = { Color = e_fg } },
  }
end)
config.window_frame = {
  active_titlebar_bg = color.background,
  button_bg = color.background,
  button_fg = color.foreground,
  button_hover_bg = color.selection_bg,
  button_hover_fg = color.selection_fg,
  inactive_titlebar_bg = color.background,
}
config.show_new_tab_button_in_tab_bar = false
config.switch_to_last_active_tab_when_closing_tab = true
if config.show_close_tab_button_in_tabs ~= nil then
  config.show_close_tab_button_in_tabs = false
end

config.enable_scroll_bar = true
config.font = wezterm.font_with_fallback({
  "CaskaydiaCove NF",
  "Cascadia Mono PL",
  "Noto Sans Mono",
})
config.font_size = 13
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
wezterm.on("gui-startup", function(cmd)
  local tab, pane, window = wezterm.mux.spawn_window(cmd or {})
  window:gui_window():maximize()
end)

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
