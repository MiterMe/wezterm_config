local wezterm = require("wezterm")
local M = {}

function M.load(config)
	config.front_end = "WebGpu"
	config.webgpu_power_preference = "HighPerformance"
	config.max_fps = 120
	config.animation_fps = 120
	config.enable_tab_bar = true
	config.hide_tab_bar_if_only_one_tab = false
	config.enable_scroll_bar = false
	config.use_fancy_tab_bar = true

	-- -- === 鼠标：选择即复制到系统剪贴板（对应 tmux 的 mouse 复制）===
	-- -- 注：旧配置无条件 CopyTo 会在“点击聚焦”（无选中）时把空字符串写入剪贴板，
	-- -- 导致外部 Ctrl+C 的内容被清空。改为仅在有选中时才写入。
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

	config.audible_bell = "Disabled"
	config.visual_bell = { fade_in_duration_ms = 0, fade_out_duration_ms = 0 }
	config.line_height = 1.0
	config.cell_width = 1.0
	config.bold_brightens_ansi_colors = false
	config.enable_kitty_keyboard = false

end

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
	local pane = tab.active_pane
	local osc_str = pane.title or ""
	-- OSC 标题格式为 "$IN_USE_SHELL $PWD"，只拆分第一个空格。
	local in_use_shell, pwd = osc_str:match("^(%S+) (.+)$")
	local mux_pane = wezterm.mux.get_pane(pane.pane_id)
	local window = mux_pane and mux_pane:window()
	local workspace = window and window:get_workspace() or "?"

	if not in_use_shell then
		return string.format("[%s] %s", workspace, osc_str)
	end
	return string.format("[%s-%s] %s", workspace, in_use_shell, pwd)
end)

wezterm.on("format-window-title", function(tab, pane, tabs, panes, config)
		return "WezTerm"
	end
)

return M
