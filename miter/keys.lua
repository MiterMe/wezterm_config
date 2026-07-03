local wezterm = require("wezterm")
local act = wezterm.action

local M = {}

function M.load(config)
	config.disable_default_key_bindings = true

	config.keys = {
		{ key = "p", mods = "SHIFT|CTRL", action = act.ActivateCommandPalette },
		{ key = "v", mods = "SHIFT|ALT", action = act.PasteFrom("Clipboard") },
		{ key = "r", mods = "SHIFT|ALT", action = act.ReloadConfiguration },
		{ key = 't', mods = 'SHIFT|ALT', action = act.SpawnTab("CurrentPaneDomain") },
		{ key = 'h', mods = 'ALT', action = act.ActivateTabRelative(-1) },
		{ key = 'l', mods = 'ALT', action = act.ActivateTabRelative(1) },
		{ key = 'LeftArrow', mods = 'ALT', action = act.ActivateTabRelative(-1) },
		{ key = 'RightArrow', mods = 'ALT', action = act.ActivateTabRelative(1) },
		{ key = 'p', mods = 'SHIFT|ALT', action = act.SplitPane({ direction = "Right" }) },
		{ key = 'd', mods = 'SHIFT|ALT', action = act.SplitPane({ direction = "Down" }) },
		{ key = 'h', mods = 'SHIFT|ALT', action = act.ActivatePaneDirection("Left") },
		{ key = 'j', mods = 'SHIFT|ALT', action = act.ActivatePaneDirection("Down") },
		{ key = 'k', mods = 'SHIFT|ALT', action = act.ActivatePaneDirection("Up") },
		{ key = 'l', mods = 'SHIFT|ALT', action = act.ActivatePaneDirection("Right") },
	}
end

return M
