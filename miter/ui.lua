local M = {}

function M.load(config)
	config.front_end = "WebGpu"
	config.webgpu_power_preference = "HighPerformance"

	config.enable_tab_bar = true
	config.hide_tab_bar_if_only_one_tab = false

	config.max_fps = 120
	config.animation_fps = 60
end

return M
