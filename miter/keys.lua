local wezterm = require("wezterm")
local act = wezterm.action

local M = {}

function M.load(config, gen_spawn_command_func)
	config.disable_default_key_bindings = true

	config.keys = {
		{ key = "p", mods = "SHIFT|CTRL", action = act.ActivateCommandPalette },
		{ key = "r", mods = "SHIFT|ALT", action = act.ReloadConfiguration },
		
		{ key = "v", mods = "SHIFT|ALT", action = act.PasteFrom("Clipboard") },
		{ key = "v", mods = "CTRL|SHIFT", action = act.PasteFrom("Clipboard") },
		{ key = "Insert", mods = "SHIFT", action = act.PasteFrom("Clipboard") },

		{ key = "t", mods = "SHIFT|ALT", action = act.SpawnCommandInNewTab{} },
		{ key = "h", mods = "ALT", action = act.ActivateTabRelative(-1) },
		{ key = "l", mods = "ALT", action = act.ActivateTabRelative(1) },

		{ key = "p", mods = "SHIFT|ALT", action = act.SplitHorizontal{} },
		{ key = "d", mods = "SHIFT|ALT", action = act.SplitVertical{} },

		{ key = "h", mods = "SHIFT|ALT", action = act.ActivatePaneDirection("Left") },
		{ key = "j", mods = "SHIFT|ALT", action = act.ActivatePaneDirection("Down") },
		{ key = "k", mods = "SHIFT|ALT", action = act.ActivatePaneDirection("Up") },
		{ key = "l", mods = "SHIFT|ALT", action = act.ActivatePaneDirection("Right") },

		{ key = "LeftArrow", mods = "ALT", action = act.AdjustPaneSize({ "Left", 5 }) },
		{ key = "RightArrow", mods = "ALT", action = act.AdjustPaneSize({ "Right", 5 }) },
		{ key = "UpArrow", mods = "ALT", action = act.AdjustPaneSize({ "Up", 5 }) },
		{ key = "DownArrow", mods = "ALT", action = act.AdjustPaneSize({ "Down", 5 }) },

		{ key = "o", mods = "SHIFT|ALT", action = act.ActivateKeyTable({ name = "session_mode" }) },

		{ key = "x", mods = "SHIFT|ALT", action = act.ActivateCopyMode },
	}

	config.key_tables = {
		session_mode = {
			{ key = "s", action = act.ShowLauncherArgs({ flags = "WORKSPACES" }) },
			{
				key = "n",
				action = act.PromptInputLine({
					description = "Enter new workspace name",
					action = wezterm.action_callback(function(window, pane, line)
						if line and #line > 0 then
							window:perform_action(act.SwitchToWorkspace({ name = line }), pane)
						end
					end),
				}),
			},
			{ key = "d", action = act.DetachDomain("CurrentPaneDomain") },
			{ key = "Escape", action = "PopKeyTable" },
		},

		copy_mode = {
			{ key = "h", mods = "NONE", action = act.CopyMode("MoveLeft") },
			{ key = "j", mods = "NONE", action = act.CopyMode("MoveDown") },
			{ key = "k", mods = "NONE", action = act.CopyMode("MoveUp") },
			{ key = "l", mods = "NONE", action = act.CopyMode("MoveRight") },
			{ key = "w", mods = "NONE", action = act.CopyMode("MoveForwardWord") },
			{ key = "b", mods = "NONE", action = act.CopyMode("MoveBackwardWord") },
			{ key = "e", mods = "NONE", action = act.CopyMode("MoveForwardWordEnd") },
			{ key = "0", mods = "NONE", action = act.CopyMode("MoveToStartOfLine") },
			{ key = "^", mods = "NONE", action = act.CopyMode("MoveToStartOfLineContent") },
			{ key = "$", mods = "NONE", action = act.CopyMode("MoveToEndOfLineContent") },
			{ key = "g", mods = "NONE", action = act.CopyMode("MoveToScrollbackTop") },
			{ key = "G", mods = "NONE", action = act.CopyMode("MoveToScrollbackBottom") },
			{ key = "H", mods = "NONE", action = act.CopyMode("MoveToViewportTop") },
			{ key = "M", mods = "NONE", action = act.CopyMode("MoveToViewportMiddle") },
			{ key = "L", mods = "NONE", action = act.CopyMode("MoveToViewportBottom") },
			{ key = "v", mods = "NONE", action = act.CopyMode({ SetSelectionMode = "Cell" }) },
			{ key = "V", mods = "NONE", action = act.CopyMode({ SetSelectionMode = "Line" }) },
			{ key = "v", mods = "CTRL", action = act.CopyMode({ SetSelectionMode = "Block" }) },
			{ key = "o", mods = "NONE", action = act.CopyMode("MoveToSelectionOtherEnd") },
			{ key = "O", mods = "NONE", action = act.CopyMode("MoveToSelectionOtherEndHoriz") },
			{ key = "/", mods = "NONE", action = act.CopyMode("EditPattern") },
			{ key = "?", mods = "NONE", action = act.CopyMode("EditPattern") },
			{ key = "n", mods = "NONE", action = act.CopyMode("NextMatch") },
			{ key = "N", mods = "NONE", action = act.CopyMode("PriorMatch") },
			{ key = "y", mods = "NONE", action = act.Multiple({ act.CopyTo("ClipboardAndPrimarySelection"), act.CopyMode("Close") }) },
			{ key = "Y", mods = "NONE", action = act.Multiple({ act.CopyTo("ClipboardAndPrimarySelection"), act.CopyMode("Close") }) },
			{ key = "Enter", mods = "NONE", action = act.Multiple({ act.CopyTo("ClipboardAndPrimarySelection"), act.CopyMode("Close") }) },
			{ key = "Escape", mods = "NONE", action = act.CopyMode("Close") },
			{ key = "q", mods = "NONE", action = act.CopyMode("Close") },
		},
	}
end

return M
