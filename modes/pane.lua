local wezterm = require("wezterm")
local act = wezterm.action

return {
	{ key = "d", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
	{ key = "n", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
}
