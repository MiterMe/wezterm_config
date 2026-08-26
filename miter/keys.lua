local wezterm = require("wezterm")
local act = wezterm.action

local M = {}

-- WSL 域下 pane:get_current_working_dir() 返回的是宿主 Windows 路径（如 /C:/Users/miter），
-- 直接回喂给 WSL 进程会 chdir 失败。转换成 WSL 认得的 /mnt/c/... 再作为新 pane 的 cwd。
local function to_wsl_cwd(url)
	if not url then
		return nil
	end
	local p = url.file_path
	local drive, rest = p:match("^/(%a):(.*)$")
	if drive then
		return "/mnt/" .. drive:lower() .. rest
	end
	return p
end

-- 切分 pane（对应 tmux split-window）：继承当前 pane 的工作目录
local function split_pane(direction)
	return wezterm.action_callback(function(window, pane)
		local cwd = pane:get_current_working_dir()
		window:perform_action(
			act.SplitPane({
				direction = direction,
				command = { cwd = to_wsl_cwd(cwd) },
			}),
			pane
		)
	end)
end

-- 新建 tab（对应 tmux new-window）：继承当前 pane 的工作目录
local function new_tab()
	return wezterm.action_callback(function(window, pane)
		local cwd = pane:get_current_working_dir()
		window:perform_action(
			act.SpawnTab({ domain = "CurrentPaneDomain", cwd = to_wsl_cwd(cwd) }),
			pane
		)
	end)
end

function M.load(config)
	config.disable_default_key_bindings = true

	config.keys = {
		-- === 通用 ===
		{ key = "p", mods = "SHIFT|CTRL", action = act.ActivateCommandPalette },
		{ key = "r", mods = "SHIFT|ALT", action = act.ReloadConfiguration },
		{ key = "v", mods = "SHIFT|ALT", action = act.PasteFrom("Clipboard") },

		-- === Window / Tab 操作（对应 tmux M-T / M-h / M-l）===
		-- Alt+Shift+T 新建窗口 (tab)，继承当前目录
		{ key = "t", mods = "SHIFT|ALT", action = new_tab() },
		-- Alt+h 上一个窗口
		{ key = "h", mods = "ALT", action = act.ActivateTabRelative(-1) },
		-- Alt+l 下一个窗口
		{ key = "l", mods = "ALT", action = act.ActivateTabRelative(1) },

		-- === Pane 操作（对应 tmux M-P / M-D / M-H/J/K/L）===
		-- Alt+Shift+P 右侧新建 pane（水平分割，= tmux split-window -h）
		{ key = "p", mods = "SHIFT|ALT", action = split_pane("Right") },
		-- Alt+Shift+D 下方新建 pane（垂直分割，= tmux split-window -v）
		{ key = "d", mods = "SHIFT|ALT", action = split_pane("Down") },
		-- Alt+Shift+H/J/K/L 切换 pane 焦点
		{ key = "h", mods = "SHIFT|ALT", action = act.ActivatePaneDirection("Left") },
		{ key = "j", mods = "SHIFT|ALT", action = act.ActivatePaneDirection("Down") },
		{ key = "k", mods = "SHIFT|ALT", action = act.ActivatePaneDirection("Up") },
		{ key = "l", mods = "SHIFT|ALT", action = act.ActivatePaneDirection("Right") },

		-- === 调整 pane 大小（对应 tmux M-Left/Right/Up/Down resize-pane -L/R/U/D 5）===
		{ key = "LeftArrow", mods = "ALT", action = act.AdjustPaneSize({ "Left", 5 }) },
		{ key = "RightArrow", mods = "ALT", action = act.AdjustPaneSize({ "Right", 5 }) },
		{ key = "UpArrow", mods = "ALT", action = act.AdjustPaneSize({ "Up", 5 }) },
		{ key = "DownArrow", mods = "ALT", action = act.AdjustPaneSize({ "Down", 5 }) },

		-- === Session 模式（对应 tmux M-O 进入 session_mode；wezterm 用 workspace 对应 tmux session）===
		-- Alt+Shift+O 进入 session 模式
		{ key = "o", mods = "SHIFT|ALT", action = act.ActivateKeyTable({ name = "session_mode" }) },

		-- === Copy 模式（对应 tmux M-X copy-mode）===
		-- Alt+Shift+X 进入 copy 模式
		{ key = "x", mods = "SHIFT|ALT", action = act.ActivateCopyMode },
	}

	config.key_tables = {
		-- session 模式：对应 tmux 的 session_mode 键表
		session_mode = {
			-- s 选择 / 切换 workspace（对应 tmux choose-session）
			{ key = "s", action = act.ShowLauncherArgs({ flags = "WORKSPACES" }) },
			-- n 新建 workspace（对应 tmux new-session）
			{
				key = "n",
				action = act.PromptInputLine({
					description = "Enter new workspace name",
					action = wezterm.action_callback(function(window, pane, line)
						if line and #line > 0 then
							window:perform_action(act.SwitchToWorkspace({ name = line }), pane)
						end
					end),
				}),
			},
			-- d 分离当前 domain（对应 tmux detach-client；需要本地 mux server / unix domain 才生效）
			{ key = "d", action = act.DetachDomain("CurrentPaneDomain") },
			-- Escape 退出 session 模式
			{ key = "Escape", action = "PopKeyTable" },
		},

		-- copy 模式：vi 风格（对应 tmux mode-keys vi + copy-mode-vi 绑定）
		copy_mode = {
			-- 移动（h/j/k/l/w/b/e/0/^/$/g/G）
			{ key = "h", mods = "NONE", action = act.CopyMode("MoveLeft") },
			{ key = "j", mods = "NONE", action = act.CopyMode("MoveDown") },
			{ key = "k", mods = "NONE", action = act.CopyMode("MoveUp") },
			{ key = "l", mods = "NONE", action = act.CopyMode("MoveRight") },
			{ key = "w", mods = "NONE", action = act.CopyMode("MoveForwardWord") },
			{ key = "b", mods = "NONE", action = act.CopyMode("MoveBackwardWord") },
			{ key = "e", mods = "NONE", action = act.CopyMode("MoveForwardWordEnd") },
			{ key = "0", mods = "NONE", action = act.CopyMode("MoveToStartOfLine") },
			{ key = "^", mods = "NONE", action = act.CopyMode("MoveToStartOfLineContent") },
			{ key = "$", mods = "NONE", action = act.CopyMode("MoveToEndOfLineContent") },
			{ key = "g", mods = "NONE", action = act.CopyMode("MoveToScrollbackTop") },
			{ key = "G", mods = "NONE", action = act.CopyMode("MoveToScrollbackBottom") },
			{ key = "H", mods = "NONE", action = act.CopyMode("MoveToViewportTop") },
			{ key = "M", mods = "NONE", action = act.CopyMode("MoveToViewportMiddle") },
			{ key = "L", mods = "NONE", action = act.CopyMode("MoveToViewportBottom") },
			-- 选择模式（v / V / Ctrl+v 矩形）
			{ key = "v", mods = "NONE", action = act.CopyMode({ SetSelectionMode = "Cell" }) },
			{ key = "V", mods = "NONE", action = act.CopyMode({ SetSelectionMode = "Line" }) },
			{ key = "v", mods = "CTRL", action = act.CopyMode({ SetSelectionMode = "Block" }) },
			{ key = "o", mods = "NONE", action = act.CopyMode("MoveToSelectionOtherEnd") },
			{ key = "O", mods = "NONE", action = act.CopyMode("MoveToSelectionOtherEndHoriz") },
			-- 搜索（/ ? n N）
			{ key = "/", mods = "NONE", action = act.CopyMode("EditPattern") },
			{ key = "?", mods = "NONE", action = act.CopyMode("EditPattern") },
			{ key = "n", mods = "NONE", action = act.CopyMode("NextMatch") },
			{ key = "N", mods = "NONE", action = act.CopyMode("PriorMatch") },
			-- 复制并退出（对应 tmux y copy-pipe-and-cancel）
			{ key = "y", mods = "NONE", action = act.Multiple({ act.CopyTo("ClipboardAndPrimarySelection"), act.CopyMode("Close") }) },
			{ key = "Y", mods = "NONE", action = act.Multiple({ act.CopyTo("ClipboardAndPrimarySelection"), act.CopyMode("Close") }) },
			{ key = "Enter", mods = "NONE", action = act.Multiple({ act.CopyTo("ClipboardAndPrimarySelection"), act.CopyMode("Close") }) },
			-- 退出 copy 模式（对应 tmux Escape cancel）
			{ key = "Escape", mods = "NONE", action = act.CopyMode("Close") },
			{ key = "q", mods = "NONE", action = act.CopyMode("Close") },
		},
	}
end

return M
