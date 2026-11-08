local wezterm = require("wezterm")
local themes = require("miter.themes")
local fonts = require("miter.fonts")
local keys = require("miter.keys")
local ui = require("miter.ui")

local config = wezterm.config_builder()

themes.load(config)
fonts.load(config)
keys.load(config)
ui.load(config)

config.ssh_backend = "Ssh2"

-- 平台差异统一在入口处理，覆盖模块提供的公共配置。

local target = wezterm.target_triple
local is_windows = target:find("windows") ~= nil
local is_macos = target:find("darwin") ~= nil

if is_windows then
	config.font_size = 10
	config.term = "xterm-256color"
	config.default_prog = { "nu", "-l" }
	config.default_ssh_auth_sock = "\\\\.\\pipe\\openssh-ssh-agent"
elseif is_macos then
	config.font_size = 12
	config.window_decorations = "INTEGRATED_BUTTONS | RESIZE"
	config.term = "wezterm"
	config.default_ssh_auth_sock = wezterm.home_dir .. "/.bitwarden-ssh-agent.sock"
else
	config.font_size = 10
	config.term = "wezterm"
end

return config
