local wezterm = require("wezterm")
local act = wezterm.action

return {
	{ key = "n", action = act.SpawnTab("CurrentPaneDomain") },
}
