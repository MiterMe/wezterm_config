local wezterm = require("wezterm")
local M = {}

function M.load(config)
	local gpus = wezterm.gui.enumerate_gpus()
	config.webgpu_preferred_adapter = gpus[1]
	config.front_end = "WebGpu"

	config.enable_tab_bar = true
	config.hide_tab_bar_if_only_one_tab = false
end

return M
