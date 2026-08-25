local wezterm = require("wezterm")
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
	config.enable_tab_bar = true
	config.hide_tab_bar_if_only_one_tab = true
	config.enable_scroll_bar = false
	config.use_fancy_tab_bar = true

	-- === 滚动缓冲优化 ===
	-- 10000 对应 tmux 的 history-limit 10000
	config.scrollback_lines = 10000
	config.alternate_buffer_wheel_scroll_speed = 3

	-- === 鼠标：选择即复制到系统剪贴板（对应 tmux 的 mouse 复制）===
	-- 注：本版本 wezterm 已移除 selection_clipboard / copy_on_select 配置字段，
	-- 选择复制改用 mouse binding 显式声明（Windows 下默认行为亦会复制）。
	config.mouse_bindings = config.mouse_bindings or {}
	table.insert(config.mouse_bindings, {
		event = { Up = { streak = 1, button = "Left" } },
		action = wezterm.action.CopyTo("ClipboardAndPrimarySelection"),
	})

	-- === Copy 模式高亮（everforest 配色，对应 tmux mode-style）===
	config.colors = {
		selection_bg = "#7fbbb3", -- blue
		selection_fg = "#293136", -- bg_dim
		copy_mode_active_highlight_bg = { Color = "#7fbbb3" },
		copy_mode_active_highlight_fg = { Color = "#293136" },
		copy_mode_inactive_highlight_bg = { Color = "#5c3f4f" }, -- bg_visual
		copy_mode_inactive_highlight_fg = { Color = "#d3c6aa" }, -- fg
	}

	-- === 终端设置 ===
	-- config.term = "xterm-256color"
	config.term = "wezterm"

	-- === 禁用不必要效果 ===
	config.audible_bell = "Disabled"
	config.visual_bell = { fade_in_duration_ms = 0, fade_out_duration_ms = 0 }

	-- === 性能微调 ===
	config.line_height = 1.0
	config.cell_width = 1.0
	config.bold_brightens_ansi_colors = false
	config.enable_kitty_keyboard = true

	-- === 光标核心配置 ===
  -- config.default_cursor_style = 'BlinkingBlock'
  -- config.cursor_blink_rate = 500
  -- config.cursor_blink_ease_in = 'Constant'
  -- config.cursor_blink_ease_out = 'Constant'

	-- === Tab 标题 ===
	wezterm.on("format-tab-title", function(tab, _, _, _, _, _)
		local tab_num = tab.tab_index + 1
		return "Tab " .. tab_num
	end)
end

return M
