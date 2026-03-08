local wezterm = require("wezterm")
local config = wezterm.config_builder()

local domains = require("miter.domains")
local themes = require("miter.themes")
local ui = require("miter.ui")
local fonts = require("miter.fonts")
local events = require("miter.events")
local keys = require("miter.keys")

domains.load(config)
themes.load(config)
ui.load(config)
fonts.load(config)
events.load()
keys.load(config)

return config
