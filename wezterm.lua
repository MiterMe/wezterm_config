local wezterm = require("wezterm")
local config = wezterm.config_builder()
local mux = wezterm.mux

local themes = require("miter.themes")
local ui = require("miter.ui")
local fonts = require("miter.fonts")
local keys = require("miter.keys")
local domains = require("miter.domains")

local target = wezterm.target_triple
local is_windows = target:find("windows") ~= nil

config.mux_enable_ssh_agent = false
config.default_gui_startup_args = { 'connect', 'unix' }

local default_shell = nil
if is_windows then
  default_shell = { 'C:/Users/miter/AppData/Local/Microsoft/WindowsApps/pwsh.exe', '-NoLogo' }
else
  default_shell = { 'bash', '-l' }
end

config.default_prog = default_shell
wezterm.on('mux-startup', function()
  local tab, pane, window = mux.spawn_window {}    
end)

domains.load(config)
themes.load(config)
ui.load(config)
fonts.load(config)
keys.load(config)

return config
