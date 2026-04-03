local M = {}

function M.load(config)
	config.enable_wayland = true
	config.prefer_egl = true
	config.front_end = "WebGpu"
	config.webgpu_power_preference = "HighPerformance"
	config.enable_tab_bar = false
	config.hide_tab_bar_if_only_one_tab = true
	config.term = "wezterm"
end

return M
