local wezterm = require("wezterm")
local M = {}

local function rich_text(txt)
	local name = "MODE: " .. txt:upper() .. "  "
	-- return wezterm.format({
	-- { Background = { Color = "#fab387" } }, -- 橙色背景
	-- { Foreground = { Color = "#1e1e2e" } }, -- 深色文字
	-- { Text = name or "" },
	-- })
	return name
end

function M.load()
	wezterm.on("update-status", function(window)
		local name = window:active_key_table()
		if name then
			window:set_right_status(rich_text(name))
			return
		end
		if window:leader_is_active() then
			window:set_right_status(rich_text("LEADER"))
			return
		end
		window:set_right_status("")
	end)
end

return M
