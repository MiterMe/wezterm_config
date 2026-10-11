local wezterm = require("wezterm")
local themes = require("miter.themes")
local fonts = require("miter.fonts")
local keys = require("miter.keys")
local ui = require("miter.ui")

local config = wezterm.config_builder()
local mux = wezterm.mux

themes.load(config)
fonts.load(config, is_macos)
keys.load(config)

local target = wezterm.target_triple
local is_windows = target:find("windows") ~= nil
local is_macos = target:find("darwin") ~= nil

local domain_name = nil
local default_program = nil
if is_windows then
	config.term = "xterm-256color"
  domain_name = "Windows"
  default_program = { 'pwsh.exe', '--Login', '--NoLogo' }
  config.default_ssh_auth_sock = '\\\\.\\pipe\\openssh-ssh-agent'
elseif is_macos then
  config.window_decorations= "INTEGRATED_BUTTONS | RESIZE"
  config.term = "wezterm"
  domain_name = "MacOS"
else
  config.term = "wezterm"
  domain_name = "Linux"
end

config.ssh_backend = 'Ssh2'
config.mux_enable_ssh_agent = true
config.unix_domains = {
  {
    name = domain_name,
    no_serve_automatically = true,
  }
}
config.default_gui_startup_args = { 'connect', domain_name }

wezterm.on('mux-startup', function()
  print(default_program)
  if default_program then
    local tab, pane, window = mux.spawn_window { args = default_program, workspace = domain_name }
  else
    local tab, pane, window = mux.spawn_window {  }
  end
end)

wezterm.on('gui-attached', function(domain)
  ui.load(config)
end)


return config
