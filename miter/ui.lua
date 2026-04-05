local M = {}

function M.load(config)
	-- === GPU/渲染优化 ===
	config.enable_wayland = true
	config.front_end = "WebGpu"
	config.prefer_egl = true
	config.webgpu_power_preference = "HighPerformance"

	-- === 显示性能优化 ===
	config.max_fps = 120
	config.animation_fps = 1
	config.cursor_blink_rate = 0
	config.cursor_blink_ease_in = "Constant"
	config.cursor_blink_ease_out = "Constant"

	-- === 字体渲染性能 ===
	config.freetype_load_target = "Light"
	config.freetype_render_target = "HorizontalLcd"

	-- === UI 极简 ===
	config.enable_tab_bar = false
	config.hide_tab_bar_if_only_one_tab = true
	config.enable_scroll_bar = false
	config.window_decorations = "RESIZE"
	config.use_fancy_tab_bar = false

	-- === 滚动缓冲优化 ===
	config.scrollback_lines = 5000
	config.alternate_buffer_wheel_scroll_speed = 3

	-- === 终端设置 ===
	config.term = "wezterm"

	-- === 禁用不必要效果 ===
	config.enable_kitty_graphics = false
	config.enable_wayland_client_side_decorations = false
end

return M
