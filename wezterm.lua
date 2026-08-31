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
if is_windows then
  config.default_prog = { 'C:/Users/miter/AppData/Local/Microsoft/WindowsApps/pwsh.exe', '-NoLogo' }
end

config.mux_enable_ssh_agent = false

domains.load(config)
themes.load(config)
ui.load(config)
fonts.load(config)
keys.load(config)

return config
