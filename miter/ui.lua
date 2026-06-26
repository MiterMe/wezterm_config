local M = {}

function M.load(config)
	-- === GPU/渲染优化 ===
	--config.enable_wayland = true
	config.front_end = "WebGpu"
	config.prefer_egl = true
	config.webgpu_power_preference = "HighPerformance"

	-- === 显示性能优化 ===
	config.max_fps = 120
	config.animation_fps = 120

	-- === UI 极简 ===
	config.enable_tab_bar = false
	config.hide_tab_bar_if_only_one_tab = true
	config.enable_scroll_bar = false
	config.use_fancy_tab_bar = false

	-- === 滚动缓冲优化 ===
	config.scrollback_lines = 5000
	config.alternate_buffer_wheel_scroll_speed = 3

	-- === 终端设置 ===
	config.term = "wezterm"

	-- === 禁用不必要效果 ===
	config.audible_bell = "Disabled"
	config.visual_bell = { fade_in_duration_ms = 0, fade_out_duration_ms = 0 }

	-- === 性能微调 ===
	config.line_height = 1.0
	config.cell_width = 1.0
	config.bold_brightens_ansi_colors = false
	config.enable_kitty_keyboard = false
end

return M
