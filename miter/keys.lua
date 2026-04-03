local wezterm = require("wezterm")
local act = wezterm.action

local copy_mode = require("modes/copy")
-- local pane_mode = require("modes/pane")
-- local tab_mode = require("modes/tab")
-- local workspace_mode = require("modes/workspace")

local M = {}

function M.load(config)
	config.disable_default_key_bindings = true
	config.leader = { key = "Space", mods = "SHIFT|ALT", timeout_milliseconds = 1000 }

	config.keys = {
		{ key = "p", mods = "SHIFT|CTRL", action = act.ActivateCommandPalette },

		-- { key = "h", mods = "ALT", action = act.ActivateTabRelative(-1) },
		-- { key = "l", mods = "ALT", action = act.ActivateTabRelative(1) },

		-- { key = "h", mods = "SHIFT|ALT", action = act.ActivatePaneDirection("Left") },
		-- { key = "l", mods = "SHIFT|ALT", action = act.ActivatePaneDirection("Right") },
		-- { key = "k", mods = "SHIFT|ALT", action = act.ActivatePaneDirection("Up") },
		-- { key = "j", mods = "SHIFT|ALT", action = act.ActivatePaneDirection("Down") },

		-- { key = "LeftArrow", mods = "SHIFT|ALT", action = act.AdjustPaneSize({ "Left", 1 }) },
		-- { key = "RightArrow", mods = "SHIFT|ALT", action = act.AdjustPaneSize({ "Right", 1 }) },
		-- { key = "UpArrow", mods = "SHIFT|ALT", action = act.AdjustPaneSize({ "Up", 1 }) },
		-- { key = "DownArrow", mods = "SHIFT|ALT", action = act.AdjustPaneSize({ "Down", 1 }) },

		{ key = "x", mods = "SHIFT|ALT", action = act.ActivateCopyMode },
		{ key = "v", mods = "SHIFT|ALT", action = act.PasteFrom("Clipboard") },

		{
			key = "r",
			mods = "SHIFT|ALT",
			action = act.ReloadConfiguration,
		},
		-- {
		-- 	key = "p",
		-- 	mods = "SHIFT|ALT",
		-- 	action = act.ActivateKeyTable({
		-- 		name = "pane_mode",
		-- 		one_shot = true,
		-- 		timeout_milliseconds = 1000,
		-- 	}),
		-- },
		-- {
		-- 	key = "t",
		-- 	mods = "SHIFT|ALT",
		-- 	action = act.ActivateKeyTable({
		-- 		name = "tab_mode",
		-- 		one_shot = true,
		-- 		timeout_milliseconds = 1000,
		-- 	}),
		-- },
		-- {
		-- 	key = "o",
		-- 	mods = "SHIFT|ALT",
		-- 	action = act.ActivateKeyTable({
		-- 		name = "workspace_mode",
		-- 		one_shot = true,
		-- 		timeout_milliseconds = 1000,
		-- 	}),
		-- },
	}
	config.key_tables = {
		-- pane_mode = pane_mode,
		-- tab_mode = tab_mode,
		-- workspace_mode = workspace_mode,
		copy_mode = copy_mode,
	}
end

return M
