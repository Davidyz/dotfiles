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

---@type Config
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
local external_color, _ = wezterm.color.load_scheme(
  (os.getenv("HOME") or os.getenv("UserProfile"))
    .. "/.config/wezterm/tokyonight-storm.toml"
)

config.enable_scroll_bar = true
config.colors = external_color
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
    (os.getenv("SystemRoot") or "C:\\Windows\\")
      .. "\\System32\\WindowsPowerShell\\v1.0\\powershell.exe",
    "-NoLogo",
  }
elseif string.find(wezterm.target_triple, "linux") ~= nil then
  config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"
end

config.hide_tab_bar_if_only_one_tab = true
return config
