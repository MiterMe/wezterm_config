local wezterm = require("wezterm")
local act = wezterm.action

local M = {}

function M.load(config)
	config.disable_default_key_bindings = true

	config.keys = {
		{ key = "p", mods = "SHIFT|CTRL", action = act.ActivateCommandPalette },
		{ key = "r", mods = "SHIFT|ALT", action = act.ReloadConfiguration },
		{ key = "v", mods = "SHIFT|ALT", action = act.PasteFrom("Clipboard") },
		-- { key = 'x', mods = 'SHIFT|ALT', action = act.ActivateCopyMode },
		-- { key = 't', mods = 'SHIFT|ALT', action = act.SpawnTab("CurrentPaneDomain") },
		-- { key = 'h', mods = 'ALT', action = act.ActivateTabRelative(-1) },
		-- { key = 'l', mods = 'ALT', action = act.ActivateTabRelative(1) },
		-- { key = 'LeftArrow', mods = 'ALT', action = act.ActivateTabRelative(-1) },
		-- { key = 'RightArrow', mods = 'ALT', action = act.ActivateTabRelative(1) },
		-- { key = 'p', mods = 'SHIFT|ALT', action = act.SplitPane({ direction = "Right" }) },
		-- { key = 'd', mods = 'SHIFT|ALT', action = act.SplitPane({ direction = "Down" }) },
		-- { key = 'h', mods = 'SHIFT|ALT', action = act.ActivatePaneDirection("Left") },
		-- { key = 'j', mods = 'SHIFT|ALT', action = act.ActivatePaneDirection("Down") },
		-- { key = 'k', mods = 'SHIFT|ALT', action = act.ActivatePaneDirection("Up") },
		-- { key = 'l', mods = 'SHIFT|ALT', action = act.ActivatePaneDirection("Right") },
	}

	-- config.key_tables = {
	-- 	copy_mode = {
	-- 		{ key = 'h', mods = 'NONE', action = act.CopyMode 'MoveLeft' },
	-- 		{ key = 'j', mods = 'NONE', action = act.CopyMode 'MoveDown' },
	-- 		{ key = 'k', mods = 'NONE', action = act.CopyMode 'MoveUp' },
	-- 		{ key = 'l', mods = 'NONE', action = act.CopyMode 'MoveRight' },
	-- 		{ key = 'w', mods = 'NONE', action = act.CopyMode 'MoveForwardWord' },
	-- 		{ key = 'b', mods = 'NONE', action = act.CopyMode 'MoveBackwardWord' },
	-- 		{ key = 'e', mods = 'NONE', action = act.CopyMode 'MoveForwardWordEnd' },
	-- 		{ key = '0', mods = 'NONE', action = act.CopyMode 'MoveToStartOfLine' },
	-- 		{ key = '^', mods = 'NONE', action = act.CopyMode 'MoveToStartOfLineContent' },
	-- 		{ key = '$', mods = 'NONE', action = act.CopyMode 'MoveToEndOfLineContent' },
	-- 		{ key = 'v', mods = 'NONE', action = act.CopyMode { SetSelectionMode = 'Cell' } },
	-- 		{ key = 'V', mods = 'NONE', action = act.CopyMode { SetSelectionMode = 'Line' } },
	-- 		{ key = 'y', mods = 'NONE', action = act.Multiple { act.CopyTo 'ClipboardAndPrimarySelection', act.CopyMode 'Close' } },
	-- 		{ key = 'Y', mods = 'NONE', action = act.Multiple { act.CopyTo 'ClipboardAndPrimarySelection', act.CopyMode 'Close' } },
	-- 		{ key = '/', mods = 'NONE', action = act.CopyMode 'EditPattern' },
	-- 		{ key = '?', mods = 'NONE', action = act.CopyMode 'EditPattern' },
	-- 		{ key = 'n', mods = 'NONE', action = act.CopyMode 'NextMatch' },
	-- 		{ key = 'N', mods = 'NONE', action = act.CopyMode 'PriorMatch' },
	-- 		{ key = 'g', mods = 'NONE', action = act.CopyMode 'MoveToScrollbackTop' },
	-- 		{ key = 'G', mods = 'NONE', action = act.CopyMode 'MoveToScrollbackBottom' },
	-- 		{ key = 'Space', mods = 'NONE', action = act.CopyMode { SetSelectionMode = 'Cell' } },
	-- 		{ key = 'Enter', mods = 'NONE', action = act.Multiple { act.CopyTo 'ClipboardAndPrimarySelection', act.CopyMode 'Close' } },
	-- 		{ key = 'q', mods = 'NONE', action = act.CopyMode 'Close' },
	-- 		{ key = 'Escape', mods = 'NONE', action = act.CopyMode 'Close' },
	-- 	},
	-- }
end

return M
