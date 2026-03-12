local wezterm = require("wezterm")
local act = wezterm.action

return {
	{ key = "n", action = act.SpawnTab("CurrentPaneDomain") },
	{
		key = "r",
		action = act.PromptInputLine({
			description = wezterm.format({
				{ Attribute = { Intensity = "Bold" } },
				{ Foreground = { AnsiColor = "Fuchsia" } },
				{ Text = "Enter name for this Tab: " },
			}),
			action = wezterm.action_callback(function(window, pane, line)
				local tab = window:active_tab()
				if line and #line > 0 then
					tab:set_title(line)
				end
			end),
		}),
	},
}
