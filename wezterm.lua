local wezterm = require("wezterm")
local config = wezterm.config_builder()

local themes = require("miter.themes")
local ui = require("miter.ui")
local fonts = require("miter.fonts")
local keys = require("miter.keys")
local localset = require("local")

themes.load(config)
ui.load(config)
fonts.load(config)
localset.load(config)
keys.load(config)

return config
