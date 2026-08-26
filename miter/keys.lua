local wezterm = require("wezterm")
local act = wezterm.action

local M = {}

-- 通用：提取当前 pane 的 cwd（兼容 Url 对象与字符串）
-- WSL 下若探测到 Windows 盘符路径（/C:/... 或 C:/...），视为不可靠的回退值，
-- 直接丢弃以触发 default_cwd 兜底，避免错误落到 /mnt/c/Users/miter
local function normalize_cwd_for_wsl(cwd)
	if not cwd or cwd == "" then
		return nil
	end
	cwd = cwd:gsub("\\", "/")
	-- 任何含盘符的路径均视为 Windows 形态，丢弃
	if cwd:match("^/([A-Za-z]):/") or cwd:match("^/([A-Za-z]):/?$") or cwd:match("^([A-Za-z]):/") or cwd:match("^([A-Za-z]):/?$") then
		return nil
	end
	if cwd:find(":") then
		return nil
	end
	if cwd:sub(1, 1) ~= "/" then
		return nil
	end
	return cwd
end

local function get_cwd(pane)
	local cwd_uri = pane:get_current_working_dir()
	if not cwd_uri then
		return nil
	end
	local raw = nil
	if type(cwd_uri) == "string" then
		local host = cwd_uri:match("^file://([^/]*)")
		local path = cwd_uri:gsub("^file://[^/]*", "")
		path = path:gsub("%%(%x%x)", function(hex)
			return string.char(tonumber(hex, 16))
		end)
		-- wsl.localhost / wsl$ 场景：file://wsl.localhost/Ubuntu-26.04/home/miter -> /home/miter
		if host and host:lower():find("wsl") then
			path = path:gsub("^/[^/]+", "", 1)
			if path == "" then
				path = "/"
			end
		end
		raw = path ~= "" and path or nil
	elseif cwd_uri.file_path then
		raw = cwd_uri.file_path
		-- Url 对象在 WSL 下 file_path 已是正确 Linux 路径，无需额外处理；
		-- 但若 host 含 wsl 且 file_path 仍带 /<distro> 前缀则同样剥离（防御性）
		if cwd_uri.host and cwd_uri.host:lower():find("wsl") and raw then
			-- 仅当 raw 形如 /Ubuntu-26.04/home/... 时剥离首段
			if raw:match("^/[^/]+/home/") or raw:match("^/[^/]+/mnt/") then
				raw = raw:gsub("^/[^/]+", "", 1)
			end
		end
	else
		-- 兜底：尝试 tostring 后按字符串处理
		local s = tostring(cwd_uri)
		local host = s:match("^file://([^/]*)")
		local path = s:gsub("^file://[^/]*", "")
		path = path:gsub("%%(%x%x)", function(hex)
			return string.char(tonumber(hex, 16))
		end)
		if host and host:lower():find("wsl") then
			path = path:gsub("^/[^/]+", "", 1)
			if path == "" then
				path = "/"
			end
		end
		raw = path ~= "" and path or nil
	end
	if not raw then
		return nil
	end
	return normalize_cwd_for_wsl(raw)
end

-- 切分 pane：继承触发动作所在 pane 的 cwd
local function split_pane(direction)
	return wezterm.action_callback(function(window, pane)
		local cwd = get_cwd(pane)
		local action = act.SplitPane({
			direction = direction,
			command = cwd and { cwd = cwd } or nil,
		})
		window:perform_action(action, pane)
	end)
end

-- 新建 tab：继承触发动作所在 pane 的 cwd
local function new_tab()
	return wezterm.action_callback(function(window, pane)
		local cwd = get_cwd(pane)
		local action
		if cwd then
			action = act.SpawnCommandInNewTab({
				cwd = cwd,
				domain = "CurrentPaneDomain",
			})
		else
			action = act.SpawnCommandInNewTab({
				domain = "CurrentPaneDomain",
			})
		end
		window:perform_action(action, pane)
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
