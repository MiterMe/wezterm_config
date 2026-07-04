local wezterm = require("wezterm")
local config = wezterm.config_builder()

local themes = require("miter.themes")
local ui = require("miter.ui")
local fonts = require("miter.fonts")
local keys = require("miter.keys")
local target = wezterm.target_triple
local is_windows = target:find("windows") ~= nil
local is_linux = target:find("linux") ~= nil

config.mux_enable_ssh_agent = false

if is_windows then
    -- config.default_prog = { 'pwsh.exe' } 
    config.default_domain = 'WSL:Ubuntu-26.04'
else
    local localset = require("local")
    localset.load(config)
end

themes.load(config)
ui.load(config)
fonts.load(config)
keys.load(config)

return config
