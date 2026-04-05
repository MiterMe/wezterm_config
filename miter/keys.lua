local wezterm = require("wezterm")
local act = wezterm.action

local M = {}

function M.load(config)
	config.disable_default_key_bindings = true

	config.keys = {
		{ key = "p", mods = "SHIFT|CTRL", action = act.ActivateCommandPalette },
		{ key = "v", mods = "SHIFT|ALT", action = act.PasteFrom("Clipboard") },
		{ key = "r", mods = "SHIFT|ALT", action = act.ReloadConfiguration },
	}
end

return M
