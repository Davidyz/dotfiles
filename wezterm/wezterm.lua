local wezterm = require("wezterm")

local config = {}
if wezterm.config_builder then
  config = wezterm.config_builder()
end

--config.color_scheme = "OneHalfDark"
local onedark_colors, _ = wezterm.color.load_scheme(
  (os.getenv("HOME") or os.getenv("UserProfile")) .. "/.config/wezterm/onedarkpro.toml"
)

config.colors = onedark_colors
config.front_end = "WebGpu"
config.font = wezterm.font_with_fallback({
  "CaskaydiaCove NF",
  "Cascadia Mono PL",
  "Noto Sans Mono",
})
config.font_size = 13
config.harfbuzz_features = { "calt=0", "clig=0", "liga=0" }

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
  { key = "w", mods = "ALT", action = action.CloseCurrentTab({ confirm = false }) },
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
    (os.getenv("SystemRoot") or "C:\\Windows\\")
      .. "\\System32\\WindowsPowerShell\\v1.0\\powershell.exe",
    "-NoLogo",
  }
elseif string.find(wezterm.target_triple, "linux") ~= nil then
end

return config
