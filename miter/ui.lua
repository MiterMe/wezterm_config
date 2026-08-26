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

	-- === Window 标题跟随 workspace ===
	-- 切换 workspace 时，OS 窗口标题自动变为 workspace 名称
	wezterm.on("format-window-title", function(tab, pane, tabs, panes, config)
		-- 优先按 window_id 精确获取该窗口所属 workspace（多窗口场景准确）
		local workspace = nil
		if tab and tab.window_id then
			local ok, mux_win = pcall(wezterm.mux.get_window, tab.window_id)
			if ok and mux_win then
				local ok2, ws = pcall(mux_win.get_workspace, mux_win)
				if ok2 and ws and #ws > 0 then
					workspace = ws
				end
			end
		end
		-- 回退到全局 active workspace
		if not workspace or #workspace == 0 then
			local ok, ws = pcall(wezterm.mux.get_active_workspace)
			if ok and ws and #ws > 0 then
				workspace = ws
			end
		end
		if workspace and #workspace > 0 then
			return workspace
		end
		-- 最后回退到 pane 标题，避免空标题
		if tab and tab.active_pane and tab.active_pane.title and #tab.active_pane.title > 0 then
			return tab.active_pane.title
		end
		return "wezterm"
	end)
end

return M
