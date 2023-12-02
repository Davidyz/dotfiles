local wezterm = require("wezterm")

local config = {}
if wezterm.config_builder then
  config = wezterm.config_builder()
end

config.color_scheme = "OneHalfDark"
config.font = wezterm.font("CaskaydiaCove NF")
config.font_size = 13

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
  { key = "PageUp", mods = "ALT", action = action.ActivateTabRelative(-1) },
  { key = "PageDown", mods = "ALT", action = action.ActivateTabRelative(1) },
  { key = "t", mods = "ALT", action = action.SpawnTab("CurrentPaneDomain") },
  { key = "PageUp", mods = "ALT|SHIFT", action = action.MoveTabRelative(-1) },
  { key = "PageDown", mods = "ALT|SHIFT", action = action.MoveTabRelative(1) },
  { key = "w", mods = "CTRL", action = action.CloseCurrentTab({ confirm = false }) },
  { key = "+", mods = "CTRL", action = action.IncreaseFontSize },
  { key = "-", mods = "CTRL", action = action.DecreaseFontSize },
  { key = "0", mods = "CTRL", action = action.ResetFontSize },
  { key = "C", mods = "CTRL|SHIFT", action = action.CopyTo("Clipboard") },
  { key = "C", mods = "CTRL|SHIFT", action = action.PasteFrom("Clipboard") },
  { key = "+", mods = "ALT", action = action.ScrollByLine(1) },
  { key = "-", mods = "ALT", action = action.ScrollByLine(-1) },
  { key = "PageUp", mods = "WIN", action = action.ScrollByPage(-1) },
  { key = "PageDown", mods = "WIN", action = action.ScrollByPage(1) },
}
wezterm.on("gui-startup", function(cmd)
  local tab, pane, window = wezterm.mux.spawn_window(cmd or {})
  window:gui_window():maximize()
end)

return config
