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
	config.hide_tab_bar_if_only_one_tab = false
	config.enable_scroll_bar = false
	config.use_fancy_tab_bar = true

	-- === 滚动缓冲优化 ===
	-- 10000 对应 tmux 的 history-limit 10000
	config.scrollback_lines = 10000
	config.alternate_buffer_wheel_scroll_speed = 3

	-- === 鼠标：选择即复制到系统剪贴板（对应 tmux 的 mouse 复制）===
	-- 注：旧配置无条件 CopyTo 会在“点击聚焦”（无选中）时把空字符串写入剪贴板，
	-- 导致外部 Ctrl+C 的内容被清空。改为仅在有选中时才写入。
	config.mouse_bindings = config.mouse_bindings or {}
	table.insert(config.mouse_bindings, {
		event = { Up = { streak = 1, button = "Left" } },
		mods = "NONE",
		action = wezterm.action_callback(function(window, pane)
			local sel = window:get_selection_text_for_pane(pane)
			if sel and sel ~= "" then
				window:copy_to_clipboard(sel, "ClipboardAndPrimarySelection")
			end
		end),
	})
	-- Wayland/X11 下中键粘贴 PrimarySelection，右键粘贴 Clipboard（兼容外部复制）
	table.insert(config.mouse_bindings, {
		event = { Down = { streak = 1, button = "Middle" } },
		mods = "NONE",
		action = wezterm.action.PasteFrom("PrimarySelection"),
	})
	table.insert(config.mouse_bindings, {
		event = { Down = { streak = 1, button = "Right" } },
		mods = "NONE",
		action = wezterm.action.PasteFrom("Clipboard"),
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
	-- 关闭全局 kitty keyboard 协议：该协议会改变按键事件处理方式，
	-- ① 拦截 Windows IME 合成事件，导致部分汉字（先/你/好/啊…）无法输入；
	-- ② 让方向键以 CSI-u 编码发出，老 vim 不识别而原样打印（29A/29B）。
	-- opencode 等现代 TUI 会启动时自行发 CSI ?2027h 请求 kitty keyboard，
	-- 故关掉全局开关不影响它们，反而修好 IME 与 vim。
	config.enable_kitty_keyboard = false

	-- === 光标核心配置 ===
  -- config.default_cursor_style = 'BlinkingBlock'
  -- config.cursor_blink_rate = 500
  -- config.cursor_blink_ease_in = 'Constant'
  -- config.cursor_blink_ease_out = 'Constant'

	wezterm.on('format-tab-title', function(tab, tabs, panes, config, hover, max_width)
  		local pane = tab.active_pane
  		local osc_str = pane.title
  		local domain = pane.domain_name
  		title = '[' .. domain .. '] ' .. osc_str
  		return title
		end
	)

	wezterm.on("format-window-title", function(tab, pane, tabs, panes, config)
  		local domain = pane.domain_name
			return domain
		end
	)
	
end

return M
